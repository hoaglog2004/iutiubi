package asm.dao;

import java.util.List;

import asm.model.Favorite;
import asm.model.ReportFavorite;
import asm.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FavoriteDAO extends AbstractDAO<Favorite> {

	private static final Logger logger = LoggerFactory.getLogger(FavoriteDAO.class);

	public FavoriteDAO() {
		super(Favorite.class); // Tự động gọi super với Share.class
	}
	/**
     * Phương thức đặc thù để tìm một Favorite
     * dựa trên cả UserId và VideoId.
     * Dùng để kiểm tra xem user đã like video này chưa,
     * hoặc để xử lý unlike.
     *
     * @param userId ID của người dùng
     * @param videoId ID của video
     * @return Đối tượng Favorite nếu tìm thấy, ngược lại trả về null.
     */
    public Favorite findByUserIdAndVideoId(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT f FROM Favorite f " +
                          "LEFT JOIN FETCH f.user " +
                          "LEFT JOIN FETCH f.video " +
                          "WHERE f.user.id = :uid AND f.video.id = :vid";
            
            TypedQuery<Favorite> query = em.createQuery(jpql, Favorite.class);
            query.setParameter("uid", userId);
            query.setParameter("vid", videoId);
            
            return query.getSingleResult();
        } catch (NoResultException e) {
            // Không tìm thấy (user chưa like video này)
            return null;
        } finally {
            em.close();
        }
    }
    
    /**
     * Find favorites by user with eager fetch of video and category
     */
    public List<Favorite> findByUserIdWithFetch(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT DISTINCT f FROM Favorite f " +
                          "LEFT JOIN FETCH f.user " +
                          "LEFT JOIN FETCH f.video v " +
                          "LEFT JOIN FETCH v.category " +
                          "WHERE f.user.id = :uid " +
                          "ORDER BY f.likeDate DESC";
            
            TypedQuery<Favorite> query = em.createQuery(jpql, Favorite.class);
            query.setParameter("uid", userId);
            
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<ReportFavorite> getReportFavorites() {
        String jpql = "SELECT NEW asm.model.ReportFavorite("
                    + " f.video.title, "
                    + " COUNT(f), "
                    + " MAX(f.likeDate), "
                    + " MIN(f.likeDate) "
                    + ") "
                    + "FROM Favorite f "
                    + "GROUP BY f.video.title "
                    + "ORDER BY COUNT(f) DESC"; // Sắp xếp theo lượt like giảm dần

        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<ReportFavorite> query = em.createQuery(jpql, ReportFavorite.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find users who liked a video with eager fetch
     */
    public List<Favorite> findUsersWhoLikedVideo(String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT f FROM Favorite f " +
                          "LEFT JOIN FETCH f.user " +
                          "LEFT JOIN FETCH f.video " +
                          "WHERE f.video.id = :vid";

            TypedQuery<Favorite> query = em.createQuery(jpql, Favorite.class);
            query.setParameter("vid", videoId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
