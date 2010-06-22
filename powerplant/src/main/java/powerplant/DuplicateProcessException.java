package powerplant;

import powerplant.model.DeployProcess;

/**
 * Exception that an existing deployment is already running
 * 
 * @author Michael Guymon
 *
 */
public class DuplicateProcessException extends Exception {
	
	public DuplicateProcessException() {
		super();
				
	}
	
	public DuplicateProcessException( String message ) {
		super(message);	
	}
	
	public DuplicateProcessException( Throwable throwable ) {
		super( throwable );		
	}
	
	public DuplicateProcessException( String message, Throwable throwable ) {
		super(message, throwable );	
	}
}
