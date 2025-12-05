package com.iutiubi.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

/**
 * Servlet to initiate Google OAuth2 login.
 * Redirects user to Google's authorization endpoint.
 */
@WebServlet("/oauth2/google")
public class GoogleLoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Google OAuth endpoints
    private static final String AUTH_ENDPOINT = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String SCOPE = "openid email profile";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String clientId = OAuthConfig.getGoogleClientId();
        String redirectUri = OAuthConfig.getGoogleRedirectUri();
        
        // Generate state for CSRF protection
        String state = UUID.randomUUID().toString();
        HttpSession session = request.getSession();
        session.setAttribute("oauth_state", state);
        
        // Build authorization URL
        String authUrl = AUTH_ENDPOINT +
                "?client_id=" + OAuthHttpClient.urlEncode(clientId) +
                "&redirect_uri=" + OAuthHttpClient.urlEncode(redirectUri) +
                "&response_type=code" +
                "&scope=" + OAuthHttpClient.urlEncode(SCOPE) +
                "&state=" + OAuthHttpClient.urlEncode(state) +
                "&access_type=online" +
                "&prompt=select_account";
        
        response.sendRedirect(authUrl);
    }
}
