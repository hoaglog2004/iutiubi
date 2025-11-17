// [SỬA LẠI] Hàm này giờ sẽ xử lý 3 form
window.switchForm = function(form) {
    document.getElementById("loginSection").classList.remove("active");
    document.getElementById("registerSection").classList.remove("active");
    document.getElementById("forgotSection").classList.remove("active"); // <-- Thêm mới

    if (form === "login") {
        document.getElementById("loginSection").classList.add("active");
    } else if (form === "register") {
        document.getElementById("registerSection").classList.add("active");
    } else if (form === "forgot") { // <-- Thêm mới
        document.getElementById("forgotSection").classList.add("active");
    }
};

// [SỬA LẠI] Script này sẽ tự động active đúng form
// khi Servlet forward về
document.addEventListener("DOMContentLoaded", function() {
    
    // 1. Kiểm tra sự tồn tại của các form (ĐÂY LÀ KHỐI CHẨN ĐOÁN)
    const login = document.getElementById("loginSection");
    const register = document.getElementById("registerSection");
    const forgot = document.getElementById("forgotSection");

    if (!login || !register || !forgot) {
        console.error("LỖI CẤU TRÚC HTML: Một trong các ID (loginSection, registerSection, forgotSection) KHÔNG TỒN TẠI trong auth.jsp.");
        console.error("VUI LÒNG KIỂM TRA LẠI CHÍNH TẢ ID CỦA CÁC DIV FORM!");
        return; // Dừng lại để không chạy tiếp
    }
    
    // 2. Nếu mọi thứ tồn tại, chạy switchForm
    const viewToShow = "${view}" || "login"; 
    window.switchForm(viewToShow);
});