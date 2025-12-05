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
 * Servlet to initiate Facebook OAuth2 login.
 * Redirects user to Facebook's authorization endpoint.
 */
@WebServlet("/oauth2/facebook")
public class FacebookLoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Facebook OAuth endpoints
    private static final String AUTH_ENDPOINT = "https://www.facebook.com/v18.0/dialog/oauth";
    private static final String SCOPE = "email,public_profile";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String clientId = OAuthConfig.getFacebookClientId();
        String redirectUri = OAuthConfig.getFacebookRedirectUri();
        
        // Generate state for CSRF protection
        String state = UUID.randomUUID().toString();
        HttpSession session = request.getSession();
        session.setAttribute("oauth_state", state);
        
        // Build authorization URL
        String authUrl = AUTH_ENDPOINT +
                "?client_id=" + OAuthHttpClient.urlEncode(clientId) +
                "&redirect_uri=" + OAuthHttpClient.urlEncode(redirectUri) +
                "&scope=" + OAuthHttpClient.urlEncode(SCOPE) +
                "&state=" + OAuthHttpClient.urlEncode(state) +
                "&response_type=code";
        
        response.sendRedirect(authUrl);
    }
}
