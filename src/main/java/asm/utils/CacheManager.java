package asm.utils;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.concurrent.TimeUnit;

import asm.model.Category;
import asm.model.Video;

/**
 * Cache Manager using Caffeine for high-performance caching.
 * Provides caching for categories and video lists.
 */
public class CacheManager {
    
    private static final Logger logger = LoggerFactory.getLogger(CacheManager.class);
    
    // Cache for categories (1 hour TTL)
    private static Cache<String, List<Category>> categoryCache;
    
    // Cache for video lists (15 min TTL)
    private static Cache<String, List<Video>> videoListCache;
    
    // Cache for single video (15 min TTL)
    private static Cache<String, Video> videoCache;
    
    private static volatile boolean initialized = false;
    
    /**
     * Initialize all caches
     */
    public static synchronized void initialize() {
        if (initialized) {
            return;
        }
        
        logger.info("Initializing CacheManager...");
        
        // Category cache: 1 hour TTL, max 100 entries
        categoryCache = Caffeine.newBuilder()
                .expireAfterWrite(1, TimeUnit.HOURS)
                .maximumSize(100)
                .recordStats()
                .build();
        
        // Video list cache: 15 min TTL, max 1000 entries
        videoListCache = Caffeine.newBuilder()
                .expireAfterWrite(15, TimeUnit.MINUTES)
                .maximumSize(1000)
                .recordStats()
                .build();
        
        // Single video cache: 15 min TTL, max 500 entries
        videoCache = Caffeine.newBuilder()
                .expireAfterWrite(15, TimeUnit.MINUTES)
                .maximumSize(500)
                .recordStats()
                .build();
        
        initialized = true;
        logger.info("CacheManager initialized successfully");
    }
    
    /**
     * Get cached categories or return null if not cached
     * @param key Cache key
     * @return Cached categories or null
     */
    public static List<Category> getCategories(String key) {
        ensureInitialized();
        List<Category> result = categoryCache.getIfPresent(key);
        if (result != null) {
            logger.debug("Category cache hit for key: {}", key);
        }
        return result;
    }
    
    /**
     * Put categories in cache
     * @param key Cache key
     * @param categories Categories to cache
     */
    public static void putCategories(String key, List<Category> categories) {
        ensureInitialized();
        if (categories != null) {
            categoryCache.put(key, categories);
            logger.debug("Categories cached with key: {}", key);
        }
    }
    
    /**
     * Get cached video list or return null if not cached
     * @param key Cache key
     * @return Cached video list or null
     */
    public static List<Video> getVideoList(String key) {
        ensureInitialized();
        List<Video> result = videoListCache.getIfPresent(key);
        if (result != null) {
            logger.debug("Video list cache hit for key: {}", key);
        }
        return result;
    }
    
    /**
     * Put video list in cache
     * @param key Cache key
     * @param videos Videos to cache
     */
    public static void putVideoList(String key, List<Video> videos) {
        ensureInitialized();
        if (videos != null) {
            videoListCache.put(key, videos);
            logger.debug("Video list cached with key: {}", key);
        }
    }
    
    /**
     * Get cached video or return null if not cached
     * @param videoId Video ID
     * @return Cached video or null
     */
    public static Video getVideo(String videoId) {
        ensureInitialized();
        Video result = videoCache.getIfPresent(videoId);
        if (result != null) {
            logger.debug("Video cache hit for id: {}", videoId);
        }
        return result;
    }
    
    /**
     * Put video in cache
     * @param videoId Video ID
     * @param video Video to cache
     */
    public static void putVideo(String videoId, Video video) {
        ensureInitialized();
        if (video != null && videoId != null) {
            videoCache.put(videoId, video);
            logger.debug("Video cached with id: {}", videoId);
        }
    }
    
    /**
     * Invalidate specific video from cache
     * @param videoId Video ID to invalidate
     */
    public static void invalidateVideo(String videoId) {
        ensureInitialized();
        videoCache.invalidate(videoId);
        logger.debug("Video cache invalidated for id: {}", videoId);
    }
    
    /**
     * Invalidate all video list caches
     */
    public static void invalidateVideoLists() {
        ensureInitialized();
        videoListCache.invalidateAll();
        logger.debug("All video list caches invalidated");
    }
    
    /**
     * Invalidate all category caches
     */
    public static void invalidateCategories() {
        ensureInitialized();
        categoryCache.invalidateAll();
        logger.debug("All category caches invalidated");
    }
    
    /**
     * Invalidate all caches
     */
    public static void invalidateAll() {
        ensureInitialized();
        categoryCache.invalidateAll();
        videoListCache.invalidateAll();
        videoCache.invalidateAll();
        logger.info("All caches invalidated");
    }
    
    /**
     * Ensure cache manager is initialized
     */
    private static void ensureInitialized() {
        if (!initialized) {
            initialize();
        }
    }
    
    /**
     * Shutdown all caches
     */
    public static synchronized void shutdown() {
        if (!initialized) {
            return;
        }
        
        logger.info("Shutting down CacheManager...");
        
        if (categoryCache != null) {
            categoryCache.invalidateAll();
            categoryCache.cleanUp();
        }
        if (videoListCache != null) {
            videoListCache.invalidateAll();
            videoListCache.cleanUp();
        }
        if (videoCache != null) {
            videoCache.invalidateAll();
            videoCache.cleanUp();
        }
        
        initialized = false;
        logger.info("CacheManager shut down successfully");
    }
    
    /**
     * Get cache statistics for monitoring
     * @return Cache statistics as a string
     */
    public static String getStats() {
        ensureInitialized();
        StringBuilder sb = new StringBuilder();
        sb.append("Category Cache: ").append(categoryCache.stats()).append("\n");
        sb.append("Video List Cache: ").append(videoListCache.stats()).append("\n");
        sb.append("Video Cache: ").append(videoCache.stats()).append("\n");
        return sb.toString();
    }
}
