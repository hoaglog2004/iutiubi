package com.iutiubi.auth;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * OAuth Configuration helper.
 * Reads OAuth client IDs, secrets, and redirect URIs from oauth.properties.
 * Supports environment variable placeholders: ${ENV_VAR_NAME}
 */
public class OAuthConfig {
    
    private static final Properties props = new Properties();
    
    static {
        try (InputStream is = OAuthConfig.class.getClassLoader()
                .getResourceAsStream("oauth.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get a property value, resolving environment variable placeholders.
     * @param key the property key
     * @return the resolved value or empty string if not found
     */
    public static String get(String key) {
        String val = props.getProperty(key, "");
        // Resolve ${ENV_VAR} placeholders
        if (val.startsWith("${") && val.endsWith("}")) {
            String envVar = val.substring(2, val.length() - 1);
            String envVal = System.getenv(envVar);
            return envVal != null ? envVal : "";
        }
        return val;
    }
    
    // Google OAuth
    public static String getGoogleClientId() {
        return get("google.clientId");
    }
    
    public static String getGoogleClientSecret() {
        return get("google.clientSecret");
    }
    
    public static String getGoogleRedirectUri() {
        return get("google.redirectUri");
    }
    
    // Facebook OAuth
    public static String getFacebookClientId() {
        return get("facebook.clientId");
    }
    
    public static String getFacebookClientSecret() {
        return get("facebook.clientSecret");
    }
    
    public static String getFacebookRedirectUri() {
        return get("facebook.redirectUri");
    }
    
    // GitHub OAuth
    public static String getGithubClientId() {
        return get("github.clientId");
    }
    
    public static String getGithubClientSecret() {
        return get("github.clientSecret");
    }
    
    public static String getGithubRedirectUri() {
        return get("github.redirectUri");
    }
}
