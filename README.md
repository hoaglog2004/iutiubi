# Iutiubi - Video Sharing Platform

A Java-based video sharing platform built with Jakarta EE 10, featuring user management, video management, and social authentication.

## Features

### Video Management
- **YouTube Video Integration**: Manage YouTube videos with automatic thumbnail generation
- **Custom Thumbnails**: Support for custom thumbnail URLs
- **Video Categories**: Organize videos by categories
- **View Tracking**: Track video views
- **Active/Inactive Status**: Control video visibility

### User Management
- **User Profiles**: Complete user profile management with avatar support
- **Role-Based Access**: Admin and regular user roles
- **Avatar Display**: User avatars shown in admin panel and user listings

### Authentication
- **Traditional Login**: Username or email-based authentication
- **Social Login**: OAuth2 integration with Google, Facebook, and GitHub
- **Email Validation**: Prevents duplicate email registration via Google login
- **Password Security**: BCrypt password hashing with automatic migration
- **Rate Limiting**: Brute force protection with login attempt tracking

## Admin Features

### Video Administration (`/admin/videos`)

The video management interface provides:

- **Thumbnail Display**: All videos show their thumbnails in the list view
  - Automatic thumbnail generation from YouTube (using `https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg`)
  - Support for custom thumbnail URLs
  - Fallback icon when no thumbnail is available

- **Video Creation/Editing**:
  - YouTube ID (required)
  - Title and description
  - Category assignment
  - View count
  - Active/Inactive status
  - **Thumbnail URL**: Optional field - leave blank for automatic YouTube thumbnail, or provide custom URL

### User Administration (`/admin/users`)

The user management interface provides:

- **Avatar Display**: All users show their avatars in the list view
  - Displays user avatar from stored URL/path
  - Fallback to default user icon when no avatar is set
  
- **User Creation/Editing**:
  - Username (unique identifier)
  - Full name
  - Email address
  - Password (BCrypt hashed)
  - **Avatar URL**: Optional field for user profile picture
  - Admin/User role assignment

## Login & Authentication

### Traditional Login

Users can now log in using **either username or email**:

```
Field: "Tên đăng nhập hoặc Email"
Accepts: 
  - Username (e.g., "john123")
  - Email (e.g., "john@example.com")
```

The system will:
1. Look up the user by username or email
2. Verify the password using BCrypt
3. Automatically upgrade old password hashes if needed
4. Apply rate limiting to prevent brute force attacks

### Google Login

Google OAuth2 authentication with email validation:

1. User clicks "Tiếp tục với Google"
2. System redirects to Google for authentication
3. **Email Check**: Before completing registration, the system checks if the email already exists in the database
   - If email exists: Shows message **"Email đã được đăng ký"** and prevents duplicate registration
   - If email is new: Proceeds with normal registration flow
4. User is logged in and redirected to the success page

This prevents users from creating duplicate accounts via Google login when they already have a traditional account with the same email.

## Technical Stack

- **Backend**: Java 17, Jakarta EE 10
- **Persistence**: JPA/EclipseLink with SQL Server
- **Security**: BCrypt password hashing, OAuth2
- **Frontend**: JSP, Bootstrap 5, Font Awesome
- **Build Tool**: Maven

## Database Schema

### Users Table
```sql
- Id (PK, varchar) - Username
- Email (varchar) - Unique email address
- Password (varchar) - BCrypt hashed password
- Fullname (varchar) - User's full name
- Avatar (varchar) - URL/path to user's avatar image
- Admin (bit) - Role flag (1=Admin, 0=User)
- MustChangePassword (bit) - Force password change flag
```

### Video Table
```sql
- Id (PK, varchar) - YouTube video ID
- Title (varchar) - Video title
- Description (text) - Video description
- Poster (varchar) - Thumbnail URL/path
- Views (int) - View count
- Active (bit) - Visibility flag
- CategoryId (FK) - Reference to Category
```

## Build and Run

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- SQL Server database

### Build
```bash
mvn clean compile
```

### Package
```bash
mvn package
```

### Run (Development)
```bash
mvn tomcat7:run
```

The application will be available at `http://localhost:8080/`

## Configuration

### OAuth Configuration
OAuth credentials are configured in `src/main/resources/oauth.properties`:
- Google OAuth2 credentials
- Facebook OAuth2 credentials
- GitHub OAuth2 credentials

Use environment variables for sensitive values (format: `${VAR_NAME}`)

### Database Configuration
Database connection settings are in `src/main/java/META-INF/persistence.xml`

## Security Features

1. **Password Security**: All passwords are hashed using BCrypt
2. **Rate Limiting**: Login attempts are rate-limited to prevent brute force attacks
3. **CSRF Protection**: OAuth state parameter validation
4. **Session Management**: Secure session handling with HttpOnly cookies
5. **Input Validation**: Server-side validation for all user inputs

## API Endpoints

### Admin Endpoints
- `GET /admin/videos` - Video management page
- `POST /admin/videos?action=create` - Create new video
- `POST /admin/videos?action=update` - Update existing video
- `POST /admin/videos?action=delete` - Delete video
- `GET /admin/users` - User management page
- `POST /admin/users?action=create` - Create new user
- `POST /admin/users?action=update` - Update existing user

### Authentication Endpoints
- `GET /login` - Login page
- `POST /login` - Process login (accepts username or email)
- `GET /oauth2/google` - Initiate Google login
- `GET /oauth2/google/callback` - Google OAuth callback (with email validation)
- `GET /oauth2/facebook` - Initiate Facebook login
- `GET /oauth2/github` - Initiate GitHub login

## Recent Updates

### Video & User Management Enhancements
1. **Video Thumbnails**:
   - Added thumbnail display in video admin list
   - Added thumbnail upload/change UI in video form
   - Automatic thumbnail generation from YouTube URLs
   - Support for custom thumbnail URLs

2. **User Avatars**:
   - Added avatar display in user admin list
   - Added avatar URL field in user form
   - Fallback to default icon when avatar is not set

3. **Google Login Email Check**:
   - Email validation before Google sign-in completion
   - Prevents duplicate accounts with same email
   - Shows "Email đã được đăng ký" message for existing emails

4. **Login Flow Enhancement**:
   - Username field now accepts both username and email
   - Updated login form label to reflect dual capability
   - Improved error messages for failed login attempts

## License

This project is for educational purposes.

## Support

For issues or questions, please contact the development team.
