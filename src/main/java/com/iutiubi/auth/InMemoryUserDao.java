package com.iutiubi.auth;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory DAO for storing social users.
 * This is a demo implementation for testing purposes.
 * 
 * For production, implement a JdbcSocialUserDao or integrate with existing UserDAO.
 */
public class InMemoryUserDao {
    
    // Thread-safe map to store users by their unique ID (provider_providerId)
    private static final Map<String, SocialUser> users = new ConcurrentHashMap<>();
    
    /**
     * Find a user by their unique ID (provider_providerId).
     * @param id the unique user ID
     * @return the SocialUser or null if not found
     */
    public SocialUser findById(String id) {
        return users.get(id);
    }
    
    /**
     * Find a user by provider and provider ID.
     * @param provider the OAuth provider (google, facebook, github)
     * @param providerId the user's ID from the provider
     * @return the SocialUser or null if not found
     */
    public SocialUser findByProviderAndProviderId(String provider, String providerId) {
        String id = provider + "_" + providerId;
        return users.get(id);
    }
    
    /**
     * Find a user by email.
     * @param email the user's email
     * @return the SocialUser or null if not found
     */
    public SocialUser findByEmail(String email) {
        if (email == null) {
            return null;
        }
        for (SocialUser user : users.values()) {
            if (email.equals(user.getEmail())) {
                return user;
            }
        }
        return null;
    }
    
    /**
     * Save or update a user.
     * @param user the SocialUser to save
     */
    public void save(SocialUser user) {
        if (user != null && user.getId() != null) {
            users.put(user.getId(), user);
        }
    }
    
    /**
     * Delete a user by ID.
     * @param id the unique user ID
     */
    public void delete(String id) {
        users.remove(id);
    }
    
    /**
     * Check if a user exists by ID.
     * @param id the unique user ID
     * @return true if the user exists
     */
    public boolean exists(String id) {
        return users.containsKey(id);
    }
    
    /**
     * Get all users (for debugging/testing).
     * @return a map of all users
     */
    public Map<String, SocialUser> findAll() {
        return new ConcurrentHashMap<>(users);
    }
    
    /**
     * Clear all users (for testing).
     */
    public void clear() {
        users.clear();
    }
}
