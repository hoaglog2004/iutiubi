package asm.dao;

import asm.model.User;
import asm.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

public class UserDAO extends AbstractDAO<User> {

	public UserDAO() {
		super(User.class);
		// TODO Auto-generated constructor stub
	}
	// --- Các phương thức đặc thù cho User ---

	/**
	 * Kiểm tra đăng nhập
	 * 
	 * @param userId
	 * @param password
	 * @return User nếu tìm thấy, null nếu sai
	 */
	public User checkLogin(String userId, String password) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			// JPQL: Java Persistence Query Language
			String jpql = "SELECT u FROM User u WHERE u.id = :uid AND u.password = :pass";
			TypedQuery<User> query = em.createQuery(jpql, User.class);

			query.setParameter("uid", userId);
			query.setParameter("pass", password); // Cảnh báo: nên mã hóa mật khẩu

			return query.getSingleResult();
		} catch (NoResultException e) {
			// Không tìm thấy kết quả, trả về null
			return null;
		} finally {
			em.close();
		}
	}

	/**
	 * Tìm User theo Email (dùng cho chức năng quên mật khẩu)
	 * 
	 * @param email
	 * @return User hoặc null
	 */
	public User findByEmail(String email) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			String jpql = "SELECT u FROM User u WHERE u.email = :email";
			TypedQuery<User> query = em.createQuery(jpql, User.class);
			query.setParameter("email", email);
			return query.getSingleResult();
		} catch (NoResultException e) {
			return null;
		} finally {
			em.close();
		}
	}

	public User findByEmailOrUsername(String identifier) {
        EntityManager em = JpaUtils.getEntityManager();
        // JPQL sẽ kiểm tra 'identifier' khớp với Email HOẶC Id
        String jpql = "SELECT u FROM User u WHERE u.email = :id OR u.id = :id";
        try {
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("id", identifier); 
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
}
}