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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Callback servlet for GitHub OAuth2.
 * Handles the authorization code exchange and user info retrieval.
 */
@WebServlet("/oauth2/github/callback")
public class GithubCallbackServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(GithubCallbackServlet.class);
    
    // GitHub OAuth endpoints
    private static final String TOKEN_ENDPOINT = "https://github.com/login/oauth/access_token";
    private static final String USER_ENDPOINT = "https://api.github.com/user";
    private static final String EMAILS_ENDPOINT = "https://api.github.com/user/emails";
    
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
            logger.warn("GitHub OAuth error: {} - {}", error, errorDescription);
            request.setAttribute("error", "Đăng nhập GitHub thất bại: " + error);
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
                throw new IOException("Failed to obtain access token from GitHub");
            }
            
            // Get user info
            SocialUser user = getUserInfo(accessToken);
            
            if (user == null) {
                throw new IOException("Failed to obtain user info from GitHub");
            }
            
            // Save user if not exists
            if (!userDao.exists(user.getId())) {
                userDao.save(user);
                logger.info("New GitHub user registered: {}", user.getEmail());
            }
            
            // Store user in session
            session.setAttribute("socialUser", user);
            
            logger.info("GitHub login successful for user: {}", user.getEmail());
            
            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/social-success.jsp");
            
        } catch (Exception e) {
            logger.error("GitHub OAuth callback error", e);
            request.setAttribute("error", "Đăng nhập GitHub thất bại: " + e.getMessage());
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
        }
    }
    
    /**
     * Exchange authorization code for access token.
     */
    private String exchangeCodeForToken(String code) throws IOException {
        String clientId = OAuthConfig.getGithubClientId();
        String clientSecret = OAuthConfig.getGithubClientSecret();
        String redirectUri = OAuthConfig.getGithubRedirectUri();
        
        String formData = "client_id=" + OAuthHttpClient.urlEncode(clientId) +
                "&client_secret=" + OAuthHttpClient.urlEncode(clientSecret) +
                "&code=" + OAuthHttpClient.urlEncode(code) +
                "&redirect_uri=" + OAuthHttpClient.urlEncode(redirectUri);
        
        Map<String, String> headers = new HashMap<>();
        headers.put("Accept", "application/json");
        
        String responseBody = OAuthHttpClient.post(TOKEN_ENDPOINT, formData, headers);
        
        return OAuthHttpClient.simpleJsonGet(responseBody, "access_token");
    }
    
    /**
     * Get user info from GitHub using access token.
     */
    private SocialUser getUserInfo(String accessToken) throws IOException {
        Map<String, String> headers = new HashMap<>();
        headers.put("Authorization", "Bearer " + accessToken);
        headers.put("Accept", "application/json");
        headers.put("User-Agent", "Iutiubi-App");
        
        // Get basic user info
        String userResponse = OAuthHttpClient.get(USER_ENDPOINT, headers);
        
        String id = OAuthHttpClient.simpleJsonGet(userResponse, "id");
        String name = OAuthHttpClient.simpleJsonGet(userResponse, "name");
        String login = OAuthHttpClient.simpleJsonGet(userResponse, "login");
        String avatarUrl = OAuthHttpClient.simpleJsonGet(userResponse, "avatar_url");
        String email = OAuthHttpClient.simpleJsonGet(userResponse, "email");
        
        // If email is null, try to get it from the emails endpoint
        if (email == null || email.isEmpty()) {
            email = getPrimaryEmail(accessToken, headers);
        }
        
        // Use login as name if name is not available
        if (name == null || name.isEmpty()) {
            name = login;
        }
        
        if (id == null) {
            return null;
        }
        
        return new SocialUser("github", id, email, name, avatarUrl);
    }
    
    /**
     * Get primary email from GitHub emails endpoint.
     */
    private String getPrimaryEmail(String accessToken, Map<String, String> headers) throws IOException {
        String emailsResponse = OAuthHttpClient.get(EMAILS_ENDPOINT, headers);
        
        // Find primary email using regex
        // GitHub returns: [{"email":"...","primary":true,"verified":true},...]
        Pattern pattern = Pattern.compile(
                "\\{[^}]*\"email\"\\s*:\\s*\"([^\"]+)\"[^}]*\"primary\"\\s*:\\s*true[^}]*\\}",
                Pattern.DOTALL
        );
        Matcher matcher = pattern.matcher(emailsResponse);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        
        // Fallback: try to find any verified email
        pattern = Pattern.compile(
                "\\{[^}]*\"email\"\\s*:\\s*\"([^\"]+)\"[^}]*\"verified\"\\s*:\\s*true[^}]*\\}",
                Pattern.DOTALL
        );
        matcher = pattern.matcher(emailsResponse);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        
        return null;
    }
}
