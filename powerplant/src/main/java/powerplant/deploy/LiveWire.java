package powerplant.deploy;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 * Implementation of {@link Runnable} to execute a {@link Deployable}
 * deployment.
 * 
 * @author Michael Guymon
 *
 */
public class LiveWire extends Thread {

	private Log log = LogFactory.getLog( this.getClass() );
	Deployable deployable;
	
	public LiveWire( Deployable deployable ) {
		this.deployable = deployable;
	}
	
	/**
	 * Executes the {@link Deployable#beforeStart()}, {@link Deployable#execute()},
	 * and {@link Deployable#afterFinish()} of a {@link Deployable}.
	 */
	public void execute() {
		boolean success = false;
		try {
			this.deployable.beforeStart();
			success = true;
		} catch ( Exception e ){		
			this.log.error( "Failed to call beforeStart", e );
			this.deployable.onError( e );
		}
		
		if ( success ) {
			try {			
				this.deployable.execute();			
			} catch( Exception e ) {
				success = false;
				this.log.error( "Failed to call execute", e );
				this.deployable.onError( e );
			}
		}
		
		if ( success ) {
			try {
				this.deployable.afterFinish();
			} catch ( Exception e ) {
				success = false;
				this.log.error( "Failed to call afterFinish", e );
				this.deployable.onError( e );
			}
		}
	}

    @Override
    public void run() {
        execute();
    }

}
