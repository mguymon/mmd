package powerplant;

// Sun JSE
import java.util.Date;

// Redhat Hibernate
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.exception.ConstraintViolationException;

// Spring
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

//Slackworks Powerplant
import org.springframework.transaction.CannotCreateTransactionException;
import powerplant.model.Deploy;
import powerplant.model.DeployProcess;

/**
 * Deploy Data Access Object
 * 
 * @author Michael Guymon
 *
 */
public class DeployDAO extends HibernateDaoSupport {

  private static ThreadLocal reconnectCheck = new ThreadLocal();


	/**
	 * Get {@link DeployProcess} by Number id
	 * 
	 * @param id Number
	 * @return {@link DeployProcess}
	 */
	public DeployProcess getDeployProcess( Integer id ) {
		return ( DeployProcess )this.getSession().get( DeployProcess.class, id );
	}
	
	private static final String getDeployProcessByEnvironmentIdQuery =
		"FROM DeployProcess deployProcess " +
		"WHERE environmentId = :environmentId";
	
	
	/**
	 * Get {@link DeployProcess} by {@link Environment} Integer id
	 * 
	 * @param environmentId Integer
	 * @return {@link DeployProcess}
	 */
	public DeployProcess getDeployProcessByEnvironmentId( final Integer environmentId ) {
		return ( DeployProcess )getHibernateTemplate().execute( new HibernateCallback() {
			public Object doInHibernate(Session session) {                
	            Query dbQuery = session.createQuery( getDeployProcessByEnvironmentIdQuery );
	            dbQuery.setParameter( "environmentId", environmentId );
	            return dbQuery.uniqueResult();
	        }
		});
	}
	
	/**
	 * Create a {@link DeployProcess}
	 * 
	 * @param environment_id Integer
	 * @param deploy_id Integer
	 * @return {@link DeployProcess}
	 * @throws DuplicateProcessException if {@link DeployProcess} already exists
	 */
	public DeployProcess createDeployProcess( Integer environment_id, Integer deploy_id ) throws DuplicateProcessException {
		DeployProcess deployProcess = new DeployProcess();
		deployProcess.setEnvironmentId( environment_id );
		deployProcess.setDeployId( deploy_id );
		deployProcess.setCreatedAt( new Date() );
		try {
			this.getSession().save( deployProcess );
		} catch ( ConstraintViolationException exception ) {
			this.getSession().clear();
			throw new DuplicateProcessException( exception );
    }
		return deployProcess;
	}
	
	private static final String deleteDeployProcessByDeployIdQuery =
		"DELETE FROM DeployProcess deployProcess " +
		"WHERE deploy_id = :deployId";
	
	/**
	 * Delete {@link DeployProcess} by {@link Deploy} Integer id
	 * @param deploy_id Integer
	 * 
	 * @return Integer rows deleted, should always be 0 or 1
	 */
	public Integer deleteDeployProcessByDeployId( final Integer deploy_id ) {
		return ( Integer )getHibernateTemplate().execute( new HibernateCallback() {
			public Object doInHibernate(Session session) {                
	            Query dbQuery = session.createQuery( deleteDeployProcessByDeployIdQuery );
	            dbQuery.setParameter( "deployId", deploy_id );
	            return dbQuery.executeUpdate();
	        }
		});
	}
	
	/**
	 * Update a {@link Deploy} status to completed
	 * 
	 * @param deploy_id Integer
	 * @param is_success Boolean
	 * @param note String
	 * @return {@link Deploy}
	 */
	public Deploy updateCompletedDeploy( Integer deploy_id, Boolean is_success, String note ) {		
		Deploy deploy = ( Deploy )this.getSession().get( Deploy.class, deploy_id );
		if ( deploy != null ) {
			deploy.setIsSuccess( is_success );
			deploy.setIsRunning( false );
			deploy.setNote( note );
			deploy.setCompletedAt( new Date() );
			this.getSession().save( deploy );
		}
		return deploy;
	}
    
	/**
	 * Delete a Hibernate entity
	 * 
	 * @param object Entity
	 */
	public void delete( Object object ) {
		this.getSession().delete( object );
	}
}
