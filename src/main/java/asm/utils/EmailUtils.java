package asm.utils;

import java.util.Properties;

// [SỬA LẠI] Đảm bảo TẤT CẢ import đều là 'jakarta.mail'
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException; // <-- Class bị thiếu
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtils {

    // THAY THẾ BẰNG EMAIL CỦA BẠN
    private static final String FROM_EMAIL = "longhhpd10091@fpt.edu.vn ";
    
    // THAY THẾ BẰNG MẬT KHẨU ỨNG DỤNG
    private static final String APP_PASSWORD = "ycoszyixbwwqzfqf"; 

    /**
     * Gửi email từ server Gmail
     * @param toEmail Địa chỉ email người nhận
     * @param subject Chủ đề email
     * @param body Nội dung email (hỗ trợ HTML)
     */
    // [SỬA LẠI] Ném ra 'MessagingException' cụ thể
    public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true"); 

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        };

        Session session = Session.getInstance(props, auth);

        MimeMessage msg = new MimeMessage(session);
        
        try {
            msg.setFrom(new InternetAddress(FROM_EMAIL));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail)); 
            msg.setSubject(subject, "UTF-8"); 
            msg.setContent(body, "text/html; charset=UTF-8"); 

            Transport.send(msg);
            
        } catch (MessagingException e) {
            e.printStackTrace();
            // Ném lại lỗi để Servlet có thể bắt được
            throw new MessagingException("Lỗi khi gửi email", e);
        }
    }
}