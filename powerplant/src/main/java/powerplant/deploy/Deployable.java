package powerplant.deploy;

/**
 * Deployable process
 * 
 * @author Michael Guymon
 *
 */
public interface Deployable {

	/**
	 * Called before execute
	 */
	public void beforeStart();
	
	/**
	 * Called after execute, if no errors
	 */
	public void afterFinish();
	
	/**
	 * Called if beforeStart, execute, or afterFinish throws an error
	 * @param throwable
	 */
	public void onError( Throwable throwable );
	
	/**
	 * Called after beforeStart
	 */
	public void execute();

  public String getLogFile();
	
}
