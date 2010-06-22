package powerplant.deploy;

// Sun JSE
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

//Apache common logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

// Spring
import org.springframework.context.ApplicationContext;

// JRuby
import org.jruby.Ruby;
import org.jruby.RubyHash;

// Powerplant
import powerplant.Springleton;


/**
 * Basic implementation of {@link Deployable}
 * 
 * @author Michael Guymon
 *
 */
public abstract class AbstractDeployment implements Deployable {
	protected Log log = LogFactory.getLog( this.getClass() );
	
	private static ThreadLocal<RubyHash> CONFIGURATION = new ThreadLocal<RubyHash>() {
        protected synchronized RubyHash initialValue() {
            return RubyHash.newHash( Ruby.newInstance() ); 
        }
    };

    public static RubyHash getConfiguration() {
    	return CONFIGURATION.get();
    }
    
    public static void setConfiguration( RubyHash rubyHash ) {
    	CONFIGURATION.set( rubyHash );
    }    
	
	/**
	 * Create new instance
	 */
	public AbstractDeployment() {
		log.debug( "Loading AbstractDeployment constructor" );
	}
	
	/**
	 * Called after the execution, if no errors.
	 */
	public void afterFinish() {
		log.debug( "Executing afterFinish" );
	}

	/**
	 * Called before execution
	 */
	public void beforeStart() {
		log.debug( "Executing beforeStart" );
	}
	
	/**
	 * Execute deployment process
	 */
	public void execute() {
		log.debug( "Executing execute" );
	}

	/**
	 * Called if {@link #beforeStart}, {@link #execute()}, or {@link #afterFinish()} throws
	 * and exception
	 */
	public void onError(Throwable throwable) {
		log.debug( "Executing onError" );
		
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		PrintStream printStream = new PrintStream( stream );
		throwable.printStackTrace( printStream );
		log.error( stream.toString() );
		printStream.close();
	}
	
	/**
	 * Get Bean from the Spring Context
	 * 
	 * @param beanName String
	 * @return Object
	 */
	public Object getBean( String beanName) {
		if ( this.log.isDebugEnabled() ) {
			this.log.debug( "Loading bean: " + beanName );
		}
		return Springleton.getApplicationContext().getBean( beanName );
	}
	
	/**
	 * Spring Context
	 *  
	 * @return {@link ApplicationContext}
	 */
	public ApplicationContext getApplicationContext() {
		return Springleton.getApplicationContext();
	}

}
