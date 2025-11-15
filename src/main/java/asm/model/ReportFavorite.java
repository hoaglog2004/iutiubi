package asm.model; // Hoặc package DTO của bạn

import java.util.Date;

// Đây không phải là @Entity, nó chỉ là một POJO (Plain Old Java Object)
// để hứng kết quả từ truy vấn JPQL
public class ReportFavorite {
    
    private String videoTitle;
    private Long likeCount;
    private Date newestDate;
    private Date oldestDate;

    // QUAN TRỌNG: Bạn phải tạo một constructor 
    // khớp chính xác với các trường bạn SELECT trong JPQL
    public ReportFavorite(String videoTitle, Long likeCount, Date newestDate, Date oldestDate) {
        this.videoTitle = videoTitle;
        this.likeCount = likeCount;
        this.newestDate = newestDate;
        this.oldestDate = oldestDate;
    }

    // Thêm các hàm Getter và Setter
    
    public String getVideoTitle() {
        return videoTitle;
    }

    public void setVideoTitle(String videoTitle) {
        this.videoTitle = videoTitle;
    }

    public Long getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(Long likeCount) {
        this.likeCount = likeCount;
    }

    public Date getNewestDate() {
        return newestDate;
    }

    public void setNewestDate(Date newestDate) {
        this.newestDate = newestDate;
    }

    public Date getOldestDate() {
        return oldestDate;
    }

    public void setOldestDate(Date oldestDate) {
        this.oldestDate = oldestDate;
    }
}