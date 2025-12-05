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

/**
 * Callback servlet for Facebook OAuth2.
 * Handles the authorization code exchange and user info retrieval.
 */
@WebServlet("/oauth2/facebook/callback")
public class FacebookCallbackServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(FacebookCallbackServlet.class);
    
    // Facebook OAuth endpoints
    private static final String TOKEN_ENDPOINT = "https://graph.facebook.com/v18.0/oauth/access_token";
    private static final String USERINFO_ENDPOINT = "https://graph.facebook.com/me?fields=id,name,email,picture.type(large)";
    
    private final InMemoryUserDao userDao = new InMemoryUserDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String error = request.getParameter("error");
        
        // Check for OAuth error
        if (error != null) {
            String errorDescription = request.getParameter("error_description");
            logger.warn("Facebook OAuth error: {} - {}", error, errorDescription);
            request.setAttribute("error", "Đăng nhập Facebook thất bại: " + error);
            request.setAttribute("view", "login");
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
                throw new IOException("Failed to obtain access token from Facebook");
            }
            
            // Get user info
            SocialUser user = getUserInfo(accessToken);
            
            if (user == null) {
                throw new IOException("Failed to obtain user info from Facebook");
            }
            
            // Save user if not exists
            if (!userDao.exists(user.getId())) {
                userDao.save(user);
                logger.info("New Facebook user registered: {}", user.getEmail());
            }
            
            // Store user in session
            session.setAttribute("socialUser", user);
            
            logger.info("Facebook login successful for user: {}", user.getEmail());
            
            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/social-success.jsp");
            
        } catch (Exception e) {
            logger.error("Facebook OAuth callback error", e);
            request.setAttribute("error", "Đăng nhập Facebook thất bại: " + e.getMessage());
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
        }
    }
    
    /**
     * Exchange authorization code for access token.
     */
    private String exchangeCodeForToken(String code) throws IOException {
        String clientId = OAuthConfig.getFacebookClientId();
        String clientSecret = OAuthConfig.getFacebookClientSecret();
        String redirectUri = OAuthConfig.getFacebookRedirectUri();
        
        String tokenUrl = TOKEN_ENDPOINT +
                "?client_id=" + OAuthHttpClient.urlEncode(clientId) +
                "&client_secret=" + OAuthHttpClient.urlEncode(clientSecret) +
                "&code=" + OAuthHttpClient.urlEncode(code) +
                "&redirect_uri=" + OAuthHttpClient.urlEncode(redirectUri);
        
        String responseBody = OAuthHttpClient.get(tokenUrl, null);
        
        return OAuthHttpClient.simpleJsonGet(responseBody, "access_token");
    }
    
    /**
     * Get user info from Facebook using access token.
     */
    private SocialUser getUserInfo(String accessToken) throws IOException {
        String userInfoUrl = USERINFO_ENDPOINT + "&access_token=" + OAuthHttpClient.urlEncode(accessToken);
        
        String responseBody = OAuthHttpClient.get(userInfoUrl, null);
        
        String id = OAuthHttpClient.simpleJsonGet(responseBody, "id");
        String email = OAuthHttpClient.simpleJsonGet(responseBody, "email");
        String name = OAuthHttpClient.simpleJsonGet(responseBody, "name");
        
        // Extract picture URL from nested JSON (simplified)
        String pictureUrl = extractPictureUrl(responseBody);
        
        if (id == null) {
            return null;
        }
        
        return new SocialUser("facebook", id, email, name, pictureUrl);
    }
    
    /**
     * Extract picture URL from Facebook's nested picture object.
     * Facebook returns: {"picture":{"data":{"url":"..."}}}
     */
    private String extractPictureUrl(String json) {
        // Simple regex to extract the URL from nested picture object
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
                "\"picture\"\\s*:\\s*\\{.*?\"url\"\\s*:\\s*\"([^\"]+)\"",
                java.util.regex.Pattern.DOTALL
        );
        java.util.regex.Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1).replace("\\/", "/");
        }
        return null;
    }
}
