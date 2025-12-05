package com.iutiubi.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet to handle logout for social login users.
 * Clears the session and redirects to home page.
 */
@WebServlet("/oauth2/logout")
public class LogoutServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Remove social user from session
            session.removeAttribute("socialUser");
            
            // Also remove regular user if present
            session.removeAttribute("currentUser");
            
            // Invalidate the entire session for complete logout
            session.invalidate();
        }
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
