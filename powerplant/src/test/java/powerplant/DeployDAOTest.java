package powerplant;

import org.junit.Before;
import org.junit.Test;

import org.springframework.test.AbstractTransactionalSpringContextTests;

import powerplant.DeployDAO;
import powerplant.DuplicateProcessException;
import powerplant.model.DeployProcess;


public class DeployDAOTest extends AbstractTransactionalSpringContextTests {

	private DeployDAO deployDAO;
	private DeployProcess deployProcess;

	public void onSetUp() {
		deployDAO = ( DeployDAO )this.getApplicationContext().getBean( "deployDAO" );
		assertNotNull( deployDAO );		
		
		deployProcess = deployDAO.getDeployProcess( 1 );
		if ( deployProcess != null ) {
			deployDAO.delete( deployProcess );
		}
		
		deployProcess = deployDAO.getDeployProcess( 3 );
		if ( deployProcess != null ) {
			deployDAO.delete( deployProcess );
		}
	}
	
	public void onTearDown() {
		if ( deployProcess != null ) {
			this.deployDAO.delete( deployProcess );
		}
	}
	
	public void testCreateDeployProcess() throws Exception {
		deployProcess = deployDAO.createDeployProcess( 1, 2 );
		assertEquals( deployProcess.getDeployId(), new Integer(2) );
		assertEquals( deployProcess.getEnvironmentId(), new Integer(1) );
		assertNotNull( deployProcess.getId() );			
	}
	
	public void testCreateDuplicateDeployProcess() throws Exception {
		deployProcess = deployDAO.createDeployProcess( 3, 4 );
		assertEquals( deployProcess.getDeployId(), new Integer(4) );
		assertEquals( deployProcess.getEnvironmentId(), new Integer(3) );
		assertNotNull( deployProcess.getId() );
		
		try {
			deployProcess = deployDAO.createDeployProcess( 3, 4 );
			fail( "DuplicateProcessException should have been thrown" );
		} catch( DuplicateProcessException exception ) {
			
		}		
	}
	
	protected String[] getConfigLocations() {
    	return new String[] { "applicationContext.xml", "applicationContext-datasource.xml" };
    }
}
