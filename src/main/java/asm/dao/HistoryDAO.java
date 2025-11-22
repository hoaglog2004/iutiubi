package asm.dao;

import java.util.List;
import asm.model.History;
import asm.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class HistoryDAO extends AbstractDAO<History> {

    public HistoryDAO() {
        super(History.class);
    }

    /**
     * Tìm lịch sử xem của một User cho một Video cụ thể (để cập nhật)
     */
    public History findByUserAndVideo(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        String jpql = "SELECT h FROM History h WHERE h.user.id = :uid AND h.video.id = :vid";
        try {
            TypedQuery<History> query = em.createQuery(jpql, History.class);
            query.setParameter("uid", userId);
            query.setParameter("vid", videoId);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách Lịch sử xem theo User (để hiển thị trang Lịch sử)
     */
    public List<History> findHistoryByUserId(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        String jpql = "SELECT h FROM History h WHERE h.user.id = :uid ORDER BY h.viewDate DESC";
        try {
            TypedQuery<History> query = em.createQuery(jpql, History.class);
            query.setParameter("uid", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}