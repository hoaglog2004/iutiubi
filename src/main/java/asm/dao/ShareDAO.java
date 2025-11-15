package asm.dao;
import asm.model.Share;

import java.util.List;

import asm.model.ReportShare;
import asm.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
public class ShareDAO extends AbstractDAO<Share> {

	public ShareDAO() {
		super(Share.class); // Tự động gọi super với Share.class
	}
	public List<ReportShare> getReportShares() {
        // Tên package 'com.yourproject.entity.ReportShare' phải khớp
        String jpql = "SELECT NEW asm.model.ReportShare("
                    + " s.video.title, "
                    + " COUNT(s), "
                    + " MAX(s.shareDate), "
                    + " MIN(s.shareDate) "
                    + ") "
                    + "FROM Share s "
                    + "GROUP BY s.video.title "
                    + "ORDER BY COUNT(s) DESC"; // Sắp xếp theo lượt share giảm dần

        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<ReportShare> query = em.createQuery(jpql, ReportShare.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    // =============================================
    // [HÀM MỚI 2] - DÙNG CHO BÁO CÁO TAB 3 (Lọc chi tiết)
    // =============================================
    /**
     * Tìm tất cả lịch sử share của một video cụ thể.
     * @param videoId ID của video cần lọc
     * @return List<Share>
     */
    public List<Share> findSharesByVideo(String videoId) {
        String jpql = "SELECT s FROM Share s WHERE s.video.id = :vid";

        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Share> query = em.createQuery(jpql, Share.class);
            query.setParameter("vid", videoId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
