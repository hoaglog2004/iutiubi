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
 * Servlet to initiate GitHub OAuth2 login.
 * Redirects user to GitHub's authorization endpoint.
 */
@WebServlet("/oauth2/github")
public class GithubLoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // GitHub OAuth endpoints
    private static final String AUTH_ENDPOINT = "https://github.com/login/oauth/authorize";
    private static final String SCOPE = "user:email read:user";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String clientId = OAuthConfig.getGithubClientId();
        String redirectUri = OAuthConfig.getGithubRedirectUri();
        
        // Generate state for CSRF protection
        String state = UUID.randomUUID().toString();
        HttpSession session = request.getSession();
        session.setAttribute("oauth_state", state);
        
        // Build authorization URL
        String authUrl = AUTH_ENDPOINT +
                "?client_id=" + OAuthHttpClient.urlEncode(clientId) +
                "&redirect_uri=" + OAuthHttpClient.urlEncode(redirectUri) +
                "&scope=" + OAuthHttpClient.urlEncode(SCOPE) +
                "&state=" + OAuthHttpClient.urlEncode(state);
        
        response.sendRedirect(authUrl);
    }
}
