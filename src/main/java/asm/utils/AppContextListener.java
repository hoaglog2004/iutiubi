package asm.utils;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Application context listener for managing application lifecycle.
 * Initializes resources on startup and cleans up on shutdown.
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    
    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Application starting up...");
        
        // Initialize EntityManagerFactory
        JpaUtils.initialize();
        
        // Initialize CacheManager
        CacheManager.initialize();
        
        logger.info("Application started successfully");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Application shutting down...");
        
        // Shutdown CacheManager
        CacheManager.shutdown();
        
        // Shutdown EntityManagerFactory
        JpaUtils.shutdown();
        
        // Shutdown RateLimiter
        RateLimiterUtil.shutdown();
        
        logger.info("Application shut down successfully");
    }
}
