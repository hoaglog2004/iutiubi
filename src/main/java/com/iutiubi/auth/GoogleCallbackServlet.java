package com.iutiubi.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import asm.dao.UserDAO;
import asm.model.User;

/**
 * Callback servlet for Google OAuth2.
 * Handles the authorization code exchange and user info retrieval.
 */
@WebServlet("/oauth2/google/callback")
public class GoogleCallbackServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(GoogleCallbackServlet.class);
    
    // Google OAuth endpoints
    private static final String TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";
    private static final String USERINFO_ENDPOINT = "https://www.googleapis.com/oauth2/v3/userinfo";
    
    private final InMemoryUserDao userDao = new InMemoryUserDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String error = request.getParameter("error");
        
        // Check for OAuth error
        if (error != null) {
            logger.warn("Google OAuth error: {}", error);
            request.setAttribute("error", "Đăng nhập Google thất bại: " + error);
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            return;
        }
        
        // Validate state for CSRF protection
        HttpSession session = request.getSession();
        String savedState = (String) session.getAttribute("oauth_state");
        session.removeAttribute("oauth_state");
        
        if (savedState == null || !savedState.equals(state)) {
            logger.warn("Invalid OAuth state. Expected: {}, Got: {}", savedState, state);
            request.setAttribute("error", "Phiên đăng nhập không hợp lệ. Vui lòng thử lại.");
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            return;
        }
        
        try {
            // Exchange code for access token
            String accessToken = exchangeCodeForToken(code);
            
            if (accessToken == null) {
                throw new IOException("Failed to obtain access token from Google");
            }
            
            // Get user info
            SocialUser user = getUserInfo(accessToken);
            
            if (user == null) {
                throw new IOException("Failed to obtain user info from Google");
            }
            
            // Check if email already exists in Users table
            UserDAO userDAO = new UserDAO();
            User existingUser = userDAO.findByEmail(user.getEmail());
            
            if (existingUser != null) {
                // Email already registered - show error message
                logger.warn("Google login attempt with already registered email: {}", user.getEmail());
                request.setAttribute("error", "Email đã được đăng ký");
                request.setAttribute("view", "login");
                request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
                return;
            }
            
            // Save user if not exists in social users
            if (!userDao.exists(user.getId())) {
                userDao.save(user);
                logger.info("New Google user registered: {}", user.getEmail());
            }
            
            // Store user in session
            session.setAttribute("socialUser", user);
            
            logger.info("Google login successful for user: {}", user.getEmail());
            
            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/social-success.jsp");
            
        } catch (Exception e) {
            logger.error("Google OAuth callback error", e);
            request.setAttribute("error", "Đăng nhập Google thất bại: " + e.getMessage());
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
        }
    }
    
    /**
     * Exchange authorization code for access token.
     */
    private String exchangeCodeForToken(String code) throws IOException {
        String clientId = OAuthConfig.getGoogleClientId();
        String clientSecret = OAuthConfig.getGoogleClientSecret();
        String redirectUri = OAuthConfig.getGoogleRedirectUri();
        
        String formData = "client_id=" + OAuthHttpClient.urlEncode(clientId) +
                "&client_secret=" + OAuthHttpClient.urlEncode(clientSecret) +
                "&code=" + OAuthHttpClient.urlEncode(code) +
                "&redirect_uri=" + OAuthHttpClient.urlEncode(redirectUri) +
                "&grant_type=authorization_code";
        
        Map<String, String> headers = new HashMap<>();
        headers.put("Accept", "application/json");
        
        String responseBody = OAuthHttpClient.post(TOKEN_ENDPOINT, formData, headers);
        
        return OAuthHttpClient.simpleJsonGet(responseBody, "access_token");
    }
    
    /**
     * Get user info from Google using access token.
     */
    private SocialUser getUserInfo(String accessToken) throws IOException {
        Map<String, String> headers = new HashMap<>();
        headers.put("Authorization", "Bearer " + accessToken);
        
        String responseBody = OAuthHttpClient.get(USERINFO_ENDPOINT, headers);
        
        String sub = OAuthHttpClient.simpleJsonGet(responseBody, "sub");
        String email = OAuthHttpClient.simpleJsonGet(responseBody, "email");
        String name = OAuthHttpClient.simpleJsonGet(responseBody, "name");
        String picture = OAuthHttpClient.simpleJsonGet(responseBody, "picture");
        
        if (sub == null) {
            return null;
        }
        
        return new SocialUser("google", sub, email, name, picture);
    }
}
