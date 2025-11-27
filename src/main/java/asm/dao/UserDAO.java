package asm.dao;

import asm.model.User;
import asm.utils.JpaUtils;
import asm.utils.PasswordUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserDAO extends AbstractDAO<User> {

	private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

	public UserDAO() {
		super(User.class);
	}
	// --- Các phương thức đặc thù cho User ---

	/**
	 * Kiểm tra đăng nhập với BCrypt password verification
	 * 
	 * @param userId
	 * @param password
	 * @return User nếu tìm thấy và password đúng, null nếu sai
	 */
	public User checkLogin(String userId, String password) {
		EntityManager em = JpaUtils.getEntityManager();
		try {
			// First, find user by ID
			String jpql = "SELECT u FROM User u WHERE u.id = :uid";
			TypedQuery<User> query = em.createQuery(jpql, User.class);
			query.setParameter("uid", userId);

			User user = query.getSingleResult();
			
			// Verify password using BCrypt
			if (PasswordUtils.checkPassword(password, user.getPassword())) {
				logger.debug("Login successful for user: {}", userId);
				
				// Check if password needs to be rehashed (migration from plain text)
				if (PasswordUtils.needsRehash(user.getPassword())) {
					logger.info("Upgrading password hash for user: {}", userId);
					user.setPassword(PasswordUtils.hashPassword(password));
					em.getTransaction().begin();
					em.merge(user);
					em.getTransaction().commit();
				}
				
				return user;
			} else {
				logger.debug("Invalid password for user: {}", userId);
				return null;
			}
		} catch (NoResultException e) {
			logger.debug("User not found: {}", userId);
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