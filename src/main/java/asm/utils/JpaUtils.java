package asm.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtils {
	private static EntityManagerFactory factory;

    /**
     * Lấy EntityManager
     * @return EntityManager
     */
    public static EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            // Tên "OnlineEntertainmentPU" phải GIỐNG HỆT
            // tên <persistence-unit> trong file persistence.xml
            factory = Persistence.createEntityManagerFactory("AsmJava4");
        }
        return factory.createEntityManager();
    }

    /**
     * Đóng EntityManagerFactory khi ứng dụng dừng
     */
    public static void shutdown() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
        factory = null;
    }
}
