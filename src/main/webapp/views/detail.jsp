<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${video.title}</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
<link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
<link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" />

<style>
.detail-layout {
	display: flex;
	gap: 24px;
	padding: 24px 0;
}

.detail-left {
	flex: 1;
	min-width: 0;
}

.detail-right {
	width: 400px;
	flex-shrink: 0;
}

.video-player {
	position: relative;
	padding-bottom: 56.25%;
	height: 0;
	overflow: hidden;
	background-color: #000;
	border-radius: 12px;
}

.video-player iframe {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	border: 0;
}

#autoplay-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.85);
	display: none;
	align-items: center;
	justify-content: center;
	z-index: 100;
	border-radius: 12px;
}

.autoplay-notification {
	text-align: center;
	color: #fff;
	padding: 30px;
}

.autoplay-notification #countdown {
	font-size: 24px;
	font-weight: bold;
	color: #ff0000;
}

.autoplay-notification .next-title {
	font-size: 18px;
	margin: 15px 0;
	color: #aaa;
}

.autoplay-notification button {
	margin: 5px;
	padding: 10px 20px;
	border-radius: 20px;
}

.video-main-title {
	font-size: 24px;
	font-weight: 600;
	color: #ffffff;
	margin-top: 16px;
}

.video-actions {
	display: flex;
	gap: 12px;
	margin-top: 12px;
	align-items: center;
}

.action-btn {
	background-color: #272727;
	color: #ffffff;
	border: none;
	padding: 10px 18px;
	border-radius: 20px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
	text-decoration: none;
	transition: background-color 0.2s;
}

.action-btn i {
	margin-right: 8px;
}

.action-btn:hover {
	background-color: #3a3a3a;
	color: #ffffff;
}

.video-stats-detail {
	color: #aaaaaa;
	font-size: 14px;
}

.video-description {
	background-color: #272727;
	color: #ffffff;
	padding: 16px;
	border-radius: 12px;
	margin-top: 20px;
	font-size: 14px;
	line-height: 1.6;
	white-space: pre-wrap;
}

.related-video-card {
	display: flex;
	gap: 12px;
	margin-bottom: 12px;
	text-decoration: none;
}

.related-thumbnail {
	width: 160px;
	flex-shrink: 0;
	position: relative;
}

.related-thumbnail img {
	width: 100%;
	border-radius: 8px;
}

.related-details {
	flex: 1;
	min-width: 0;
}

.related-title {
	color: #ffffff;
	font-size: 14px;
	font-weight: 500;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.related-channel {
	color: #aaaaaa;
	font-size: 12px;
	margin-top: 4px;
}

@media ( max-width : 1200px) {
	.detail-right {
		width: 350px;
	}
}

@media ( max-width : 992px) {
	.detail-layout {
		flex-direction: column;
	}
	.detail-right {
		width: 100%;
	}
}
</style>
</head>
<body>

	<jsp:include page="/common/header.jsp" />
	<jsp:include page="/common/sidebar.jsp" />

	<div class="main-content" id="mainContent" style="margin-top: -10px;">
		<div class="detail-layout">

			<div class="detail-left">
				<div class="video-player">
					<div id="player"></div>
					<div id="autoplay-overlay">
						<div class="autoplay-notification">
							<div>Video tiếp theo sẽ phát sau</div>
							<div id="countdown">5</div>
							<div class="next-title" id="next-video-title"></div>
							<button class="btn btn-primary" onclick="playNext()">Xem ngay</button>
							<button class="btn btn-secondary" onclick="cancelAutoplay()">Hủy</button>
						</div>
					</div>
				</div>

				<h1 class="video-main-title">${video.title}</h1>

				<div class="video-actions">
					<span class="video-stats-detail">${video.views} lượt xem</span> <a
						href="<c:url value='/like?videoId=${video.id}'/>"
						class="action-btn"> <i class="fas fa-thumbs-up"></i> Like
					</a> <a href="<c:url value='/share?videoId=${video.id}'/>"
						class="action-btn"> <i class="fas fa-share"></i> Chia sẻ
					</a>
				</div>

				<div class="video-description">
					<strong>Mô tả:</strong>
					<p>${video.description}</p>
				</div>
			</div>

			<div class="detail-right">
				<h4>Xem thêm</h4>

				<c:forEach var="v" items="${videoList}">
					<a href="<c:url value='/detail?videoId=${v.id}'/>"
						class="related-video-card">
						<div class="related-thumbnail">
							<img src="${v.poster}" alt="${v.title}">
						</div>
						<div class="related-details">
							<div class="related-title">${v.title}</div>
							<div class="related-channel">Kênh Test</div>
						</div>
					</a>
				</c:forEach>

			</div>

		</div>
	</div>

	<script src="<c:url value='/assets/js/app.js'/>"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

	<script>
    var player;
    var saveInterval = null;
    var autoplayTimeout = null;
    var countdownInterval = null;
    const videoId = '${video.id}';
    // Lấy thời gian lịch sử một cách an toàn (tránh lỗi nếu ${history} là null)
    const historyTime = ${history.lastTime != null ? history.lastTime : 0}; 
    const isUserLoggedIn = '${sessionScope.currentUser.id}' !== '';
    
    // Mảng chứa danh sách video liên quan
    const relatedVideos = [
        <c:forEach var="rv" items="${relatedVideos}" varStatus="status">
            {
                id: '${rv.id}',
                title: '${rv.title}'
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    // 1. HÀM KHỞI ĐỘNG PLAYER
    window.onYouTubeIframeAPIReady = function() {
        // [ĐÃ SỬA] Đảm bảo 'player' là đối tượng hợp lệ
        player = new YT.Player('player', {
            height: '100%',
            width: '100%',
            videoId: videoId,
            playerVars: { 
                'autoplay': 1, 
                'rel': 0,
                'start': historyTime 
            },
            events: {
                'onReady': onPlayerReady,
                'onStateChange': onPlayerStateChange
            }
        });
    };

    function onPlayerReady(event) {
        // Nếu đăng nhập, bắt đầu lưu trạng thái ngay lập tức
        if (isUserLoggedIn) {
            saveInterval = setInterval(savePosition, 5000); 
        }
    }
    
    function onPlayerStateChange(event) {
        if (!isUserLoggedIn) {
            // Vẫn xử lý autoplay cho người dùng chưa đăng nhập
            if (event.data == YT.PlayerState.ENDED) {
                handleVideoEnded();
            }
            return;
        }

        // Nếu video dừng lại hoặc kết thúc
        if (event.data == YT.PlayerState.PAUSED || event.data == YT.PlayerState.ENDED) {
            if (saveInterval) clearInterval(saveInterval); 
            saveInterval = null;
            savePosition(); // Lưu lần cuối khi dừng
            
            // Xử lý autoplay khi video kết thúc
            if (event.data == YT.PlayerState.ENDED) {
                handleVideoEnded();
            }
        } 
        
        // Nếu video đang phát và chưa có timer
        else if (event.data == YT.PlayerState.PLAYING && !saveInterval) {
            saveInterval = setInterval(savePosition, 5000);
        }
    }
    
    // Xử lý khi video kết thúc
    function handleVideoEnded() {
        if (relatedVideos && relatedVideos.length > 0) {
            const nextVideo = relatedVideos[0];
            showAutoplayNotification(nextVideo, 5);
        }
    }
    
    // Hiển thị thông báo autoplay với đếm ngược
    function showAutoplayNotification(nextVideo, seconds) {
        const overlay = document.getElementById('autoplay-overlay');
        const countdownElement = document.getElementById('countdown');
        const nextTitleElement = document.getElementById('next-video-title');
        
        overlay.style.display = 'flex';
        nextTitleElement.textContent = nextVideo.title;
        
        let timeLeft = seconds;
        countdownElement.textContent = timeLeft;
        
        countdownInterval = setInterval(function() {
            timeLeft--;
            countdownElement.textContent = timeLeft;
            
            if (timeLeft <= 0) {
                clearInterval(countdownInterval);
                playNext(nextVideo.id);
            }
        }, 1000);
        
        // Tự động chuyển sau 5 giây
        autoplayTimeout = setTimeout(function() {
            playNext(nextVideo.id);
        }, seconds * 1000);
    }
    
    // Chuyển sang video tiếp theo
    function playNext(videoId) {
        if (autoplayTimeout) clearTimeout(autoplayTimeout);
        if (countdownInterval) clearInterval(countdownInterval);
        
        const nextVideoId = videoId || (relatedVideos.length > 0 ? relatedVideos[0].id : null);
        if (nextVideoId) {
            window.location.href = '<c:url value="/detail"/>?videoId=' + nextVideoId;
        }
    }
    
    // Hủy autoplay
    function cancelAutoplay() {
        if (autoplayTimeout) clearTimeout(autoplayTimeout);
        if (countdownInterval) clearInterval(countdownInterval);
        
        const overlay = document.getElementById('autoplay-overlay');
        overlay.style.display = 'none';
    }

    // 2. HÀM LƯU TRẠNG THÁI (Đã sửa lỗi an toàn)
    function savePosition() {
    // 1. Kiểm tra an toàn
    if (!isUserLoggedIn || !player || player.getPlayerState() !== YT.PlayerState.PLAYING) {
        return; 
    }
    
    try {
        const currentTime = Math.floor(player.getCurrentTime());
        
        // [THÊM MỚI] Tạo đối tượng tham số an toàn
        const params = new URLSearchParams();
        params.append('videoId', videoId); // videoId đã được xác nhận là hợp lệ
        params.append('lastTime', currentTime); // currentTime là số nguyên đã làm tròn

        // 2. Gửi AJAX với body được encode chuẩn
        fetch('<c:url value="/api/history"/>', {
            method: 'POST',
            headers: { 
                // Bắt buộc phải có Content-Type này khi gửi dữ liệu dạng form-urlencoded
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString() // Gửi body đã được encode
        })
        .then(response => {
            if (response.ok) {
                console.log(`Lịch sử xem đã lưu: ${currentTime}s (Status 200)`);
            } else {
                // In ra lỗi 400, 401...
                console.error(`LỖI LƯU LỊCH SỬ: Status ${response.status}`);
            }
        })
        .catch(error => console.error('Lỗi kết nối mạng:', error));

    } catch(e) { 
        // Bắt lỗi player chưa sẵn sàng
        console.warn('Player chưa sẵn sàng hoặc lỗi JS:', e); 
    }
}

    // 3. Xử lý khi người dùng thoát trang/đóng tab
    window.addEventListener('beforeunload', function() {
        // Chỉ lưu lần cuối nếu có player và người dùng đã đăng nhập
        if (isUserLoggedIn && player && player.getPlayerState() !== 0) { // Tránh gọi khi chưa kịp khởi tạo
             savePosition();
        }
    });
    
</script>

	<script src="https://www.youtube.com/iframe_api"></script>
</body>
</html>