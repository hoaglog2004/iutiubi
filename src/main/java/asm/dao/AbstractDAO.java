package asm.dao; // Đảm bảo package này đúng

import asm.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public abstract class AbstractDAO<T> {

    private Class<T> entityClass;

    public AbstractDAO(Class<T> cls) {
        this.entityClass = cls;
    }

    // --- SỬA LẠI HÀM CREATE ---
    public void create(T entity) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity); // Lưu vào database
            em.getTransaction().commit();
        } catch (Exception e) {
            // [SỬA LỖI] Chỉ rollback nếu giao dịch CÒN HOẠT ĐỘNG
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi tạo mới: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // --- SỬA LẠI HÀM UPDATE ---
    public void update(T entity) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity); // Cập nhật
            em.getTransaction().commit();
        } catch (Exception e) {
            // [SỬA LỖI] Chỉ rollback nếu giao dịch CÒN HOẠT ĐỘNG
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // --- SỬA LẠI HÀM DELETE ---
    public void delete(Object id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            T entity = em.find(entityClass, id);
            if (entity != null) {
                em.remove(entity); // Xóa
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            // [SỬA LỖI] Chỉ rollback nếu giao dịch CÒN HOẠT ĐỘNG
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xóa: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    // Hàm findById không thay đổi
    public T findById(Object id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(entityClass, id);
        } finally {
            em.close();
        }
    }

    // Hàm findAll không thay đổi
    public List<T> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT e FROM " + entityClass.getSimpleName() + " e";
            TypedQuery<T> query = em.createQuery(jpql, entityClass);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}