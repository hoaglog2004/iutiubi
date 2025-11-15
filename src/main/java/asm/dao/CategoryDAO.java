package asm.dao;

import asm.model.Category;
import asm.utils.JpaUtils;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

// KHÔNG cần kế thừa AbstractDAO vì chúng ta chỉ cần 2 hàm đơn giản
public class CategoryDAO extends AbstractDAO<Category> {

    // [SỬA LẠI] Thêm constructor chuẩn
    public CategoryDAO() {
        super(Category.class);
    }
    /**
     * Lấy Category theo ID
     */
    public Category findById(String id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(Category.class, id);
        } finally {
            em.close();
        }
    }

    /**
     * Lấy TẤT CẢ Categories
     */
    @Override
    public List<Category> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT c FROM Category c ORDER BY c.name"; // Sắp xếp theo tên
            TypedQuery<Category> query = em.createQuery(jpql, Category.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }	
}