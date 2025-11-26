package asm.utils;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.util.concurrent.RateLimiter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Rate limiting utility using Guava RateLimiter.
 * Provides IP-based rate limiting and failed login tracking.
 */
public class RateLimiterUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(RateLimiterUtil.class);
    
    // Rate limit: 5 requests per second per IP
    private static final double REQUESTS_PER_SECOND = 5.0;
    
    // Max failed login attempts before lockout
    private static final int MAX_FAILED_ATTEMPTS = 5;
    
    // Lockout duration in minutes
    private static final int LOCKOUT_DURATION_MINUTES = 15;
    
    // Cache of rate limiters per IP (expires after 1 hour of inactivity)
    private static LoadingCache<String, RateLimiter> rateLimiterCache;
    
    // Cache of failed login attempts per IP
    private static LoadingCache<String, AtomicInteger> failedAttemptsCache;
    
    // Cache of locked out IPs
    private static LoadingCache<String, Long> lockedOutCache;
    
    private static volatile boolean initialized = false;
    
    static {
        initialize();
    }
    
    /**
     * Initialize the rate limiter caches
     */
    public static synchronized void initialize() {
        if (initialized) {
            return;
        }
        
        logger.info("Initializing RateLimiterUtil...");
        
        // Rate limiter cache: creates a new rate limiter for each IP
        rateLimiterCache = CacheBuilder.newBuilder()
                .expireAfterAccess(1, TimeUnit.HOURS)
                .maximumSize(10000)
                .build(new CacheLoader<String, RateLimiter>() {
                    @Override
                    public RateLimiter load(String key) {
                        return RateLimiter.create(REQUESTS_PER_SECOND);
                    }
                });
        
        // Failed attempts cache: tracks failed login attempts per IP
        failedAttemptsCache = CacheBuilder.newBuilder()
                .expireAfterWrite(LOCKOUT_DURATION_MINUTES, TimeUnit.MINUTES)
                .maximumSize(10000)
                .build(new CacheLoader<String, AtomicInteger>() {
                    @Override
                    public AtomicInteger load(String key) {
                        return new AtomicInteger(0);
                    }
                });
        
        // Locked out cache: tracks locked out IPs
        lockedOutCache = CacheBuilder.newBuilder()
                .expireAfterWrite(LOCKOUT_DURATION_MINUTES, TimeUnit.MINUTES)
                .maximumSize(10000)
                .build(new CacheLoader<String, Long>() {
                    @Override
                    public Long load(String key) {
                        return 0L;
                    }
                });
        
        initialized = true;
        logger.info("RateLimiterUtil initialized successfully");
    }
    
    /**
     * Check if request is allowed by rate limiter
     * @param ipAddress The client's IP address
     * @return true if request is allowed, false if rate limited
     */
    public static boolean isAllowed(String ipAddress) {
        if (ipAddress == null || ipAddress.isEmpty()) {
            return true;
        }
        
        try {
            RateLimiter limiter = rateLimiterCache.get(ipAddress);
            boolean allowed = limiter.tryAcquire();
            if (!allowed) {
                logger.warn("Rate limit exceeded for IP: {}", ipAddress);
            }
            return allowed;
        } catch (ExecutionException e) {
            logger.error("Error getting rate limiter for IP: {}", ipAddress, e);
            return true; // Fail open
        }
    }
    
    /**
     * Check if an IP is locked out due to too many failed attempts
     * @param ipAddress The client's IP address
     * @return true if locked out, false otherwise
     */
    public static boolean isLockedOut(String ipAddress) {
        if (ipAddress == null || ipAddress.isEmpty()) {
            return false;
        }
        
        try {
            Long lockoutTime = lockedOutCache.getIfPresent(ipAddress);
            if (lockoutTime != null && lockoutTime > 0) {
                long currentTime = System.currentTimeMillis();
                long remainingTime = (lockoutTime + TimeUnit.MINUTES.toMillis(LOCKOUT_DURATION_MINUTES)) 
                        - currentTime;
                if (remainingTime > 0) {
                    logger.debug("IP {} is locked out for {} more seconds", 
                            ipAddress, TimeUnit.MILLISECONDS.toSeconds(remainingTime));
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            logger.error("Error checking lockout status for IP: {}", ipAddress, e);
            return false;
        }
    }
    
    /**
     * Record a failed login attempt
     * @param ipAddress The client's IP address
     * @return true if the IP is now locked out, false otherwise
     */
    public static boolean recordFailedAttempt(String ipAddress) {
        if (ipAddress == null || ipAddress.isEmpty()) {
            return false;
        }
        
        try {
            AtomicInteger attempts = failedAttemptsCache.get(ipAddress);
            int currentAttempts = attempts.incrementAndGet();
            
            logger.debug("Failed login attempt {} for IP: {}", currentAttempts, ipAddress);
            
            if (currentAttempts >= MAX_FAILED_ATTEMPTS) {
                // Lock out the IP
                lockedOutCache.put(ipAddress, System.currentTimeMillis());
                logger.warn("IP {} locked out after {} failed attempts", ipAddress, currentAttempts);
                return true;
            }
            
            return false;
        } catch (ExecutionException e) {
            logger.error("Error recording failed attempt for IP: {}", ipAddress, e);
            return false;
        }
    }
    
    /**
     * Clear failed attempts for an IP (call on successful login)
     * @param ipAddress The client's IP address
     */
    public static void clearFailedAttempts(String ipAddress) {
        if (ipAddress == null || ipAddress.isEmpty()) {
            return;
        }
        
        failedAttemptsCache.invalidate(ipAddress);
        lockedOutCache.invalidate(ipAddress);
        logger.debug("Cleared failed attempts for IP: {}", ipAddress);
    }
    
    /**
     * Get the number of remaining attempts before lockout
     * @param ipAddress The client's IP address
     * @return Number of remaining attempts
     */
    public static int getRemainingAttempts(String ipAddress) {
        if (ipAddress == null || ipAddress.isEmpty()) {
            return MAX_FAILED_ATTEMPTS;
        }
        
        try {
            AtomicInteger attempts = failedAttemptsCache.getIfPresent(ipAddress);
            if (attempts == null) {
                return MAX_FAILED_ATTEMPTS;
            }
            return Math.max(0, MAX_FAILED_ATTEMPTS - attempts.get());
        } catch (Exception e) {
            return MAX_FAILED_ATTEMPTS;
        }
    }
    
    /**
     * Get client's real IP address from request
     * @param request HTTP request
     * @return Client's IP address
     */
    public static String getClientIp(jakarta.servlet.http.HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        
        // If X-Forwarded-For contains multiple IPs, take the first one
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        
        return ip;
    }
    
    /**
     * Shutdown the rate limiter (cleanup resources)
     */
    public static synchronized void shutdown() {
        if (!initialized) {
            return;
        }
        
        logger.info("Shutting down RateLimiterUtil...");
        
        if (rateLimiterCache != null) {
            rateLimiterCache.invalidateAll();
        }
        if (failedAttemptsCache != null) {
            failedAttemptsCache.invalidateAll();
        }
        if (lockedOutCache != null) {
            lockedOutCache.invalidateAll();
        }
        
        initialized = false;
        logger.info("RateLimiterUtil shut down successfully");
    }
}
