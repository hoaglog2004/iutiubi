/* File: assets/js/app.js */

// Toggle sidebar
function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  const mainContent = document.getElementById("mainContent");
  const filterTags = document.querySelector(".filter-tags");

  sidebar.classList.toggle("collapsed");
  mainContent.classList.toggle("expanded");

  // Update filter tags position based on sidebar state
  if (sidebar.classList.contains("collapsed")) {
    filterTags.style.left = "80px";
  } else {
    filterTags.style.left = "240px";
  }
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", function () {
  	const avatarOverlay = document.getElementById('avatarOverlay');
	    const fileInput = document.getElementById('avatarFileInput');
	    const avatarPreview = document.getElementById('avatarPreviewImg');

	    // Kiểm tra xem chúng ta có đang ở trang Edit Profile không
	    if(avatarOverlay && fileInput) {
	        
	        // 1. Kích hoạt File Input khi nhấn vào Overlay
	        avatarOverlay.addEventListener('click', function() {
	            fileInput.click(); 
	        });
	        
	        // 2. Hiển thị Preview ảnh ngay lập tức khi chọn file
	        fileInput.addEventListener('change', function(event) {
	            if (event.target.files && event.target.files[0]) {
	                const reader = new FileReader();
	                reader.onload = function(e) {
	                    avatarPreview.src = e.target.result;
	                };
	                reader.readAsDataURL(event.target.files[0]);
	            }
	        });
	    }
  // KHÔNG GỌI generateVideos() nữa, vì JSP đã tự tạo rồi.
  // KHÔNG GỌI initUserSection() nữa, vì JSP đã tự xử lý.

  // Filter tags (Giữ lại)
  const filterTags = document.querySelectorAll(".filter-tag");
  filterTags.forEach((tag) => {
    tag.addEventListener("click", function () {
      filterTags.forEach((t) => t.classList.remove("active"));
      this.classList.add("active");
    });
  });

  // Search: Tạm thời vô hiệu hóa, 
  // vì logic search nên được xử lý bởi Servlet (server-side)
  const searchInput = document.querySelector(".search-container input");
  const searchBtn = document.querySelector(".search-btn");
  
  const handleSearch = () => {
    const query = searchInput.value;
    if (query.trim()) {
        // Chuyển hướng đến Servlet tìm kiếm
        window.location.href = `search?keyword=${encodeURIComponent(query)}`;
    }
  };
  
  searchBtn.addEventListener("click", handleSearch);
  searchInput.addEventListener("keypress", function(e) {
      if (e.key === 'Enter') {
          handleSearch();
      }
  });


  // Sidebar item active state (Giữ lại)
  const sidebarItems = document.querySelectorAll(".sidebar-item");
  sidebarItems.forEach((item) => {
    item.addEventListener("click", function () {
      // Bỏ e.preventDefault() để cho phép chuyển trang
      sidebarItems.forEach((i) => i.classList.remove("active"));
      this.classList.add("active");
    });
  });
});

// TOÀN BỘ CÁC HÀM loginUser, logoutUser, initUserSection...
// ĐÃ BỊ XÓA BỎ VÌ JSP/SERVLET SẼ XỬ LÝ
document.addEventListener("DOMContentLoaded", function () {
    
    // ... (code cũ của bạn, như toggleSidebar, filterTags...)

    // --- [THÊM MỚI] LOGIC LIVE SEARCH ---
    
    const searchInput = document.getElementById("searchInput");
    const searchButton = document.getElementById("searchButton");
    const videoGrid = document.getElementById("videoGrid");
    
    // Hàm gọi AJAX
    const performSearch = (keyword) => {
        // Hiện loading (nếu muốn)
        videoGrid.innerHTML = '<p style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #aaa;">Đang tìm kiếm...</p>';
        
        // Tạo URL an toàn
        const url = `search-partial?keyword=${encodeURIComponent(keyword)}`;
        
        // Gọi Servlet "mini"
        fetch(url)
            .then(response => response.text()) // Nhận về HTML
            .then(htmlSnippet => {
                // "Nhét" đoạn HTML (từ _videoGrid.jsp) vào trang
                videoGrid.innerHTML = htmlSnippet;
            })
            .catch(error => {
                console.error("Lỗi tìm kiếm:", error);
                videoGrid.innerHTML = '<p style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #f00;">Lỗi kết nối. Vui lòng thử lại.</p>';
            });
    };

    // Biến đếm thời gian
    let debounceTimer;

    // Lắng nghe sự kiện gõ phím
    searchInput.addEventListener("keyup", (e) => {
        clearTimeout(debounceTimer); // Hủy bộ đếm cũ
        
        // Đặt bộ đếm mới. Chỉ tìm kiếm sau khi người dùng ngừng gõ 300ms
        debounceTimer = setTimeout(() => {
            const keyword = searchInput.value;
            performSearch(keyword);
        }, 300); 
    });

    // Lắng nghe sự kiện nhấn nút (nếu cần)
    searchButton.addEventListener("click", () => {
        const keyword = searchInput.value;
        performSearch(keyword);
    });

});