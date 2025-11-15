package asm.model;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.*;


/**
 * The persistent class for the Favorite database table.
 * 
 */
@Entity
@NamedQuery(name="Favorite.findAll", query="SELECT f FROM Favorite f")
public class Favorite implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="Id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	//bi-directional many-to-one association to User
	@ManyToOne
	@JoinColumn(name="UserId")
	private User user;

	//bi-directional many-to-one association to Video
	@ManyToOne
	@JoinColumn(name="VideoId")
	private Video video;

	public Favorite() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public User getUser() {
		return this.user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Video getVideo() {
		return this.video;
	}

	public void setVideo(Video video) {
		this.video = video;
	}

	@Column(name = "LikeDate")
	private Date likeDate;
	public Date getLikeDate() {
        return this.likeDate;
    }
	// Hàm setter (setLikeDate) phải gán giá trị cho trường "likeDate"
	public void setLikeDate(Date date) {
	    this.likeDate = date; // Sửa lại: Gán vào "this.likeDate"
	}

}