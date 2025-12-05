package com.iutiubi.auth;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Simple HTTP client for OAuth operations.
 * Uses JDK HttpURLConnection (no external dependencies).
 * 
 * NOTE: This is a demo implementation using regex for JSON parsing.
 * For production use, consider using Gson or Jackson.
 */
public class OAuthHttpClient {
    
    private static final int CONNECT_TIMEOUT = 10000; // 10 seconds
    private static final int READ_TIMEOUT = 10000;    // 10 seconds
    
    /**
     * Perform a GET request with optional headers.
     * @param urlString the URL to request
     * @param headers optional headers to include
     * @return the response body as a String
     * @throws IOException if the request fails
     */
    public static String get(String urlString, Map<String, String> headers) throws IOException {
        URL url = URI.create(urlString).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        try {
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            
            if (headers != null) {
                for (Map.Entry<String, String> entry : headers.entrySet()) {
                    conn.setRequestProperty(entry.getKey(), entry.getValue());
                }
            }
            
            return readResponse(conn);
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * Perform a POST request with form data.
     * @param urlString the URL to post to
     * @param formData the form data as key=value pairs joined by &
     * @param headers optional headers to include
     * @return the response body as a String
     * @throws IOException if the request fails
     */
    public static String post(String urlString, String formData, Map<String, String> headers) 
            throws IOException {
        URL url = URI.create(urlString).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        try {
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            if (headers != null) {
                for (Map.Entry<String, String> entry : headers.entrySet()) {
                    conn.setRequestProperty(entry.getKey(), entry.getValue());
                }
            }
            
            try (OutputStream os = conn.getOutputStream()) {
                os.write(formData.getBytes(StandardCharsets.UTF_8));
            }
            
            return readResponse(conn);
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * Read response body from connection.
     */
    private static String readResponse(HttpURLConnection conn) throws IOException {
        int responseCode = conn.getResponseCode();
        BufferedReader reader;
        
        if (responseCode >= 200 && responseCode < 300) {
            reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        } else {
            reader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
        }
        
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        reader.close();
        
        return sb.toString();
    }
    
    /**
     * Simple JSON value extractor using regex.
     * Extracts the value of a JSON key from a JSON string.
     * 
     * NOTE: This is a DEMO implementation. For production, use a proper JSON library.
     * 
     * @param json the JSON string
     * @param key the key to extract
     * @return the value as a String, or null if not found
     */
    public static String simpleJsonGet(String json, String key) {
        if (json == null || key == null) {
            return null;
        }
        
        // Pattern to match "key": "value" or "key": value (for numbers/booleans)
        // Also handles 'key': 'value' for some APIs
        String patternStr = "\"" + Pattern.quote(key) + "\"\\s*:\\s*\"([^\"]*?)\"";
        Pattern pattern = Pattern.compile(patternStr);
        Matcher matcher = pattern.matcher(json);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        
        // Try unquoted values (numbers, booleans, null)
        patternStr = "\"" + Pattern.quote(key) + "\"\\s*:\\s*([^,}\\]\\s]+)";
        pattern = Pattern.compile(patternStr);
        matcher = pattern.matcher(json);
        
        if (matcher.find()) {
            String val = matcher.group(1).trim();
            // Remove trailing quote if any
            if (val.endsWith("\"")) {
                val = val.substring(0, val.length() - 1);
            }
            return val.equals("null") ? null : val;
        }
        
        return null;
    }
    
    /**
     * URL encode a string.
     */
    public static String urlEncode(String s) {
        return java.net.URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
