package powerplant.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Entity for deploy_proccesses. There should only be 1 DeployProcess
 * per environment at a time.
 * 
 * @author Michael Guymon
 *
 */
@Entity
@Table( name="deploy_processes")
public class DeployProcess {

	private Integer id;
	private Integer environmentId;
	private Integer deployId;
	private Date createdAt;
	
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

	public void setEnvironmentId(Integer environmentId) {
		this.environmentId = environmentId;
	}

	@Column( name="deploy_id" )
	public Integer getDeployId() {
		return deployId;
	}

	public void setDeployId(Integer deployId) {
		this.deployId = deployId;
	}

	@Column( name="created_at" )
	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	
	
}
