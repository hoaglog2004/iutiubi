package asm.model; // Hoặc package DTO của bạn

import java.util.Date;

// Đây là POJO để hứng kết quả truy vấn thống kê Share
public class ReportShare {
    
    private String videoTitle;
    private Long shareCount;
    private Date newestDate;
    private Date oldestDate;

    // Constructor phải khớp với truy vấn JPQL
    public ReportShare(String videoTitle, Long shareCount, Date newestDate, Date oldestDate) {
        this.videoTitle = videoTitle;
        this.shareCount = shareCount;
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

    public Long getShareCount() {
        return shareCount;
    }

    public void setShareCount(Long shareCount) {
        this.shareCount = shareCount;
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