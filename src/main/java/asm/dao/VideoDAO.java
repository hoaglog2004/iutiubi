package asm.dao;

import java.util.List;
import jakarta.persistence.Query;

import asm.model.Video;
import asm.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

@SuppressWarnings("unused")
public class VideoDAO extends AbstractDAO<Video> {

	public VideoDAO() {
		super(Video.class); // Tự động gọi super với Share.class
	}
	// --- Các phương thức đặc thù cho Video ---

	/**
	 * Tìm các video được yêu thích bởi một User
	 * 
	 * @param userId
	 * @return List<Video>
	 */

	public List<Video> findFavoriteVideosByUserId(String userId) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			// Dùng JPQL để JOIN qua bảng Favorite
			String jpql = "SELECT f.video FROM Favorite f WHERE f.user.id = :uid";
			TypedQuery<Video> query = em.createQuery(jpql, Video.class);
			query.setParameter("uid", userId);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	/**
	 * Tìm video theo Tiêu đề (case-insensitive và accent-insensitive).
	 * 
	 * @param keyword Từ khóa tìm kiếm
	 * @return List<Video>
	 */
	@SuppressWarnings("unchecked")
	public List<Video> findByTitle(String keyword) {
		// Dùng Native Query (SQL thuần) thay vì JPQL
		// COLLATE Vietnamese_CI_AI: So sánh Tiếng Việt,
		// _CI (Case-Insensitive): không phân biệt hoa/thường
		// _AI (Accent-Insensitive): không phân biệt dấu (mua = mùa)
		String sql = "SELECT * FROM Video " + "WHERE Title LIKE ? COLLATE Vietnamese_CI_AI";

		EntityManager em = JpaUtils.getEntityManager();
		try {
			// Tạo một native query, chỉ định rằng kết quả trả về là class Video
			Query query = em.createNativeQuery(sql, Video.class);

			// Set tham số (giống như JDBC)
			query.setParameter(1, "%" + keyword + "%");

			return query.getResultList();

		} finally {
			em.close();
		}
	}

	public List<Video> findByCategory(String categoryId) {
		String jpql = "SELECT v FROM Video v WHERE v.category.id = :cid";

		EntityManager em = JpaUtils.getEntityManager();
		try {
			TypedQuery<Video> query = em.createQuery(jpql, Video.class);
			query.setParameter("cid", categoryId);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	public long countAll() {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			String jpql = "SELECT COUNT(v) FROM Video v";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			return query.getSingleResult();
		} finally {
			em.close();
		}
	}

	/**
	 * [MỚI] Đếm video THEO THỂ LOẠI
	 */
	public long countByCategory(String categoryId) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			String jpql = "SELECT COUNT(v) FROM Video v WHERE v.category.id = :cid";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			query.setParameter("cid", categoryId);
			return query.getSingleResult();
		} finally {
			em.close();
		}
	}

	/**
	 * [MỚI] Lấy TẤT CẢ video (có phân trang)
	 * 
	 * @param pageNumber Trang hiện tại (bắt đầu từ 1)
	 * @param pageSize   Số video mỗi trang (ví dụ: 6)
	 */
	public List<Video> findAll(int pageNumber, int pageSize) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			String jpql = "SELECT v FROM Video v ORDER BY v.views DESC";
			TypedQuery<Video> query = em.createQuery(jpql, Video.class);

			query.setFirstResult((pageNumber - 1) * pageSize); // Vị trí bắt đầu
			query.setMaxResults(pageSize); // Số lượng lấy

			return query.getResultList();
		} finally {
			em.close();
		}
	}

	/**
	 * [MỚI] Lấy video THEO THỂ LOẠI (có phân trang)
	 */
	public List<Video> findByCategory(String categoryId, int pageNumber, int pageSize) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			String jpql = "SELECT v FROM Video v WHERE v.category.id = :cid ORDER BY v.views DESC";
			TypedQuery<Video> query = em.createQuery(jpql, Video.class);

			query.setParameter("cid", categoryId);
			query.setFirstResult((pageNumber - 1) * pageSize);
			query.setMaxResults(pageSize);

			return query.getResultList();
		} finally {
			em.close();
		}
	}

	/**
	 * Tăng biến đếm lượt xem của video lên 1.
	 * 
	 * @param videoId ID của video cần tăng view
	 */
	public void incrementViewCount(String videoId) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			// 1. Bắt đầu giao dịch
			em.getTransaction().begin();

			// 2. Tìm video
			Video video = em.find(Video.class, videoId);

			if (video != null) {
				// 3. Xử lý tăng view (Thêm kiểm tra null cho an toàn)
				Integer currentViews = video.getViews();
				int newViews = (currentViews == null) ? 1 : currentViews + 1;
				video.setViews(newViews);

				// 4. Cập nhật lại vào CSDL
				em.merge(video);

				// 5. Lưu thay đổi
				em.getTransaction().commit();
			} else {
				// Nếu video không tìm thấy, hủy giao dịch
				em.getTransaction().rollback();
			}
		} catch (Exception e) {
			// Nếu có lỗi, hủy giao dịch
			if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
			e.printStackTrace();
		} finally {
			em.close();
		}
	}
}
