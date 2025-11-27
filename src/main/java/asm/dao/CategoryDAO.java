package asm.dao;

import asm.model.Category;
import asm.utils.CacheManager;
import asm.utils.JpaUtils;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

// KHÔNG cần kế thừa AbstractDAO vì chúng ta chỉ cần 2 hàm đơn giản
public class CategoryDAO extends AbstractDAO<Category> {

    private static final Logger logger = LoggerFactory.getLogger(CategoryDAO.class);
    private static final String CACHE_KEY_ALL = "all_categories";

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
     * Lấy TẤT CẢ Categories (with caching)
     */
    @Override
    public List<Category> findAll() {
        // Check cache first
        List<Category> cached = CacheManager.getCategories(CACHE_KEY_ALL);
        if (cached != null) {
            logger.debug("Returning categories from cache");
            return cached;
        }

        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT c FROM Category c ORDER BY c.name"; // Sắp xếp theo tên
            TypedQuery<Category> query = em.createQuery(jpql, Category.class);
            List<Category> result = query.getResultList();
            
            // Store in cache
            CacheManager.putCategories(CACHE_KEY_ALL, result);
            logger.debug("Categories loaded from database and cached");
            
            return result;
        } finally {
            em.close();
        }
    }

    /**
     * Invalidate the category cache (call after create/update/delete)
     */
    public void invalidateCache() {
        CacheManager.invalidateCategories();
        logger.debug("Category cache invalidated");
    }
}