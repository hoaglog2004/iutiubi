package asm.model;

import java.io.Serializable;
import jakarta.persistence.*;
import java.sql.Timestamp;
import java.util.Date;

/**
 * The persistent class for the History database table.
 * 
 */
@Entity
@Table(name = "History")
@NamedQuery(name = "History.findAll", query = "SELECT h FROM History h")
public class History implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "Id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@ManyToOne
	@JoinColumn(name = "UserId")
	private User user;

	@Column(name = "LastTime")
	private int lastTime;

	@ManyToOne
	@JoinColumn(name = "VideoId")
	private Video video; // Dùng đối tượng Video

	@Column(name = "ViewDate")
	private Date viewDate;

	public History() {
	}

	public User getUser() {
		return this.user;
	}

	public void setUser(User user) { // Hàm này nhận đối tượng User
		this.user = user;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public int getLastTime() {
		return this.lastTime;
	}

	public void setLastTime(int lastTime) {
		this.lastTime = lastTime;
	}


	public Video getVideo() {
		return this.video;
	}

	public void setVideo(Video video) { // Hàm này nhận đối tượng Video
		this.video = video;
	}

	public Date getViewDate() {
		return this.viewDate;
	}

	public void setViewDate(Date viewDate) {
		this.viewDate = viewDate;
	}

}