package powerplant.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Entity for Deploy, contains the status information
 * on a deploy.
 * 
 * @author Michael Guymon
 *
 */
@Entity
@Table( name="deploys")
public class Deploy {
	private Integer id;
	private Integer environmentId;
	private Boolean isRunning;
	private Boolean isSuccess;
	private Date completedAt;
	private Date updatedAt;
	private String note;
	
	@Id
	@GeneratedValue
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	@Column( name="environment_id" )
	public Integer getEnvironmentId() {
		return environmentId;
	}

	public void setEnvironmentId(Integer id) {
		this.environmentId = id;
	}

	@Column( name="is_running" )
	public Boolean getIsRunning() {
		return isRunning;
	}
	
	public void setIsRunning(Boolean isRunning) {
		this.isRunning = isRunning;
	}
	
	@Column( name="is_success" )
	public Boolean getIsSuccess() {
		return isSuccess;
	}
	
	public void setIsSuccess(Boolean isSuccess) {
		this.isSuccess = isSuccess;
	}
	
	@Column( name="completed_at" )
	public Date getCompletedAt() {
		return completedAt;
	}
	
	public void setCompletedAt(Date completedAt) {
		this.completedAt = completedAt;
	}
	
	@Column( name="updated_at" )
	public Date getUpdatedAt() {
		return updatedAt;
	}
	
	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}
		
	public String getNote() {
		return note;
	}
	
	public void setNote(String note) {
		this.note = note;
	}
}
