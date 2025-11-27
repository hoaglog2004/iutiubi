package asm.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JpaUtils {
	private static final Logger logger = LoggerFactory.getLogger(JpaUtils.class);
	private static volatile EntityManagerFactory factory;
	private static final Object lock = new Object();

    /**
     * Initialize the EntityManagerFactory
     */
    public static void initialize() {
        synchronized (lock) {
            if (factory == null || !factory.isOpen()) {
                logger.info("Initializing EntityManagerFactory...");
                factory = Persistence.createEntityManagerFactory("AsmJava4");
                logger.info("EntityManagerFactory initialized successfully");
            }
        }
    }

    /**
     * Lấy EntityManager
     * @return EntityManager
     */
    public static EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            synchronized (lock) {
                if (factory == null || !factory.isOpen()) {
                    initialize();
                }
            }
        }
        return factory.createEntityManager();
    }

    /**
     * Get the EntityManagerFactory instance
     * @return EntityManagerFactory
     */
    public static EntityManagerFactory getEntityManagerFactory() {
        if (factory == null || !factory.isOpen()) {
            synchronized (lock) {
                if (factory == null || !factory.isOpen()) {
                    initialize();
                }
            }
        }
        return factory;
    }

    /**
     * Đóng EntityManagerFactory khi ứng dụng dừng
     */
    public static void shutdown() {
        synchronized (lock) {
            if (factory != null && factory.isOpen()) {
                logger.info("Shutting down EntityManagerFactory...");
                factory.close();
                logger.info("EntityManagerFactory shut down successfully");
            }
            factory = null;
        }
    }
}
