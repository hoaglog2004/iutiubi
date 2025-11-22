-- T-SQL (Microsoft SQL Server) để tạo bảng WatchHistory
-- Điều chỉnh kiểu và độ dài của cột nếu cần (tương thích với cấu trúc Users.Id và Video.Id của bạn)

IF OBJECT_ID('dbo.WatchHistory', 'U') IS NOT NULL
    DROP TABLE dbo.WatchHistory;
GO

CREATE TABLE dbo.WatchHistory (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserId NVARCHAR(50) NOT NULL,
    VideoId NVARCHAR(50) NOT NULL,
    LastPosition INT NOT NULL DEFAULT 0, -- đơn vị: giây
    LastWatchedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Khóa ngoại (nếu bảng Users và Video tồn tại và có cột Id phù hợp)
ALTER TABLE dbo.WatchHistory
    ADD CONSTRAINT FK_WatchHistory_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id);
GO

ALTER TABLE dbo.WatchHistory
    ADD CONSTRAINT FK_WatchHistory_Video FOREIGN KEY (VideoId) REFERENCES dbo.Video(Id);
GO

-- Index giúp truy vấn lịch sử theo user nhanh hơn
CREATE INDEX IX_WatchHistory_User_LastWatchedAt ON dbo.WatchHistory(UserId, LastWatchedAt DESC);
GO
