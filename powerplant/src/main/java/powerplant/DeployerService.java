package powerplant;

// Sun JSE
import javax.naming.NamingException;
import javax.sql.DataSource;

// Apache Commons Logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

// JRuby
import org.jruby.Ruby;
import org.jruby.runtime.load.BasicLibraryService;

// Powerplant
import powerplant.rails.DataSourceConfig;

/**
 * JRuby Service to set the Ruby instance and start up Spring via
 * the {@link Springleton}. To be automatically loaded by JRuby,
 * must be jarred as powerplant/deployer.jar in the JRuby instances
 * relative path. Then in Ruby, calling require 'powerplant/deployer' 
 * will create a new instance and execute {@link #basicLoad(Ruby)}.
 * 
 * @author Michael Guymon
 *
 */
public class DeployerService implements BasicLibraryService {
	protected static Log log = LogFactory.getLog( DeployerService.class );
	
	private static DataSource dataSource;
	
	public DeployerService() {
		super();
		if ( log.isDebugEnabled() ) {
			log.debug("Creating new DeployService" );
		}
	}

	/**
	 * Executed by JRuby
	 */
	public boolean basicLoad(final Ruby runtime) {
		if ( log.isInfoEnabled() ) {
			log.info( "Loading Deployer Service" );
		}
		
		DataSourceConfig config = null;
		try {
			config = new DataSourceConfig( runtime );
		} catch (NamingException exception) {
			log.fatal( "Failed to lookup datasource in JNDI" );
			throw new RuntimeException( "Failed to lookup datasource in JNDI", exception );
		} catch (ClassNotFoundException exception) {
			log.fatal( "Failed to load driver in ActiveRecord config");
			throw new RuntimeException( "Failed to load driver in ActiveRecord config", exception);
		} catch ( Exception exception ) {
			log.fatal( "Failed to load database config from Rails runtime", exception );
			throw new RuntimeException( "Failed to load database config from Rails runtime", exception );
		}
		
		dataSource = config.getDataSource();
		try {
			Springleton.loadApplicationContext();
		} catch ( Exception exception ) {
			log.fatal( "Failed to create Spring context", exception );
			throw new RuntimeException( "Failed to create Spring context", exception );
		}
		
		return true;
	}
	
	public static DataSource getDataSource() {
		return dataSource;
	}
}
