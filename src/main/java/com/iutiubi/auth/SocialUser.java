package com.iutiubi.auth;

import java.io.Serializable;

/**
 * Model class representing a social login user.
 * Stores basic profile information from OAuth providers.
 */
public class SocialUser implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private String id;          // Unique ID from provider (e.g., google_123456)
    private String provider;    // Provider name: google, facebook, github
    private String providerId;  // Original ID from the provider
    private String email;
    private String name;
    private String avatarUrl;
    
    public SocialUser() {
    }
    
    public SocialUser(String provider, String providerId, String email, String name, String avatarUrl) {
        this.provider = provider;
        this.providerId = providerId;
        this.id = provider + "_" + providerId;
        this.email = email;
        this.name = name;
        this.avatarUrl = avatarUrl;
    }
    
    // Getters and Setters
    
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getProvider() {
        return provider;
    }
    
    public void setProvider(String provider) {
        this.provider = provider;
        regenerateId();
    }
    
    public String getProviderId() {
        return providerId;
    }
    
    public void setProviderId(String providerId) {
        this.providerId = providerId;
        regenerateId();
    }
    
    /**
     * Regenerates the unique ID from provider and providerId.
     */
    private void regenerateId() {
        if (this.provider != null && this.providerId != null) {
            this.id = this.provider + "_" + this.providerId;
        }
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getAvatarUrl() {
        return avatarUrl;
    }
    
    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
    @Override
    public String toString() {
        return "SocialUser{" +
                "id='" + id + '\'' +
                ", provider='" + provider + '\'' +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
