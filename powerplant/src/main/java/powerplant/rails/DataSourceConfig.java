package powerplant.rails;

// Sun JSE
import java.util.Map;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

// Apache Commons DBCP
import org.apache.commons.dbcp.cpdsadapter.DriverAdapterCPDS;
import org.apache.commons.dbcp.datasources.SharedPoolDataSource;

// Apache Commons logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

// JRuby
import org.jruby.Ruby;
import org.jruby.RubyHash;
import org.jruby.runtime.builtin.IRubyObject;


/**
 * Build a {@link DataSource} from Rails' ActiveRecord config
 * 
 * @author Michael Guymon
 * 
 */
public class DataSourceConfig {
	private static Log log = LogFactory.getLog( DataSourceConfig.class );
	private Ruby runtime;
	private DataSource dataSource;

	/**
	 * Build a {@link DataSource} from Rails' ActiveRecord config
	 * 
	 * @param runtime {@link Ruby}
	 * @throws NamingException 
	 * @throws ClassNotFoundException 
	 * @throws Throwable
	 */
	public DataSourceConfig(final Ruby runtime) throws NamingException, ClassNotFoundException {
		this.runtime = runtime;
		
		if ( log.isDebugEnabled() ) {
			log.debug( "Constructing DataSourceConfig" );
		}
		
		// Rails::Configuration.new.database_configuration()[:jndi]
		IRubyObject railsConfig = 
			runtime.getModule("Rails").getConstant("Configuration").callMethod( runtime.getCurrentContext(), "new" );
		
		RubyHash db_conf = 
			( RubyHash )railsConfig.callMethod( runtime.getCurrentContext(), "database_configuration" ).convertToHash().get( 
					railsConfig.callMethod( runtime.getCurrentContext(), "environment" ) );		
		
		String jndi = (String)db_conf.get("jndi");		
		if (jndi != null) {
			log.info( "Lookup DataSource in JNDI" );
			lookupInJNDI( jndi, db_conf );
		} else {
			log.info( "Building DataSource from ActiveRecord config" );
			buildDataSource( db_conf );
		}
	}

	protected void lookupInJNDI( String jndi, Map activeRecordConfig ) throws NamingException {
		Properties properties = new Properties();

		// Get initial context factory from ActiveRecord
		String context_factory = 
			( String )activeRecordConfig.get("jndi_factory_initial" );
		if (context_factory != null && context_factory.length() > 0) {
			log.info("Using ActiveRecord JNDI Intial Context Factory: " + context_factory);
			properties.setProperty("java.naming.factory.initial",
					context_factory);

		// Initial context factory not defined by ActiveRecord, pull from
		// System properties
		} else {
			context_factory = System.getProperty("java.naming.factory.initial");
			if (context_factory != null && context_factory.length() > 0) {
				log.info("Using System property JNDI Intial Context Factory: " + context_factory);
				properties.setProperty("java.naming.factory.initial", context_factory);
			} else {
				String errorMsg = "Rails database_configuration or System property java.naming.factory.initial did not contain initial factory, is jndi_context_factory set in database.yml?";
				log.fatal(errorMsg);
				throw new RuntimeException(errorMsg);
			}
		}

		// Get provider url from ActiveRecord
		String provider_url = (String)activeRecordConfig.get("jndi_provider_url");
		if (provider_url != null && provider_url.length() > 0) {
			log.info("Using ActiveRecord property JNDI Provider URL: " + provider_url);
			properties.setProperty("java.naming.provider.url", provider_url);

		// Provider url not defined by ActiveRecord, pull from System
		// properties
		} else {
			provider_url = System.getProperty("java.naming.provider.url");
			if (provider_url != null && provider_url.length() > 0) {
				log.info("Using System property JNDI Provider URL: " + provider_url);
				properties.setProperty("java.naming.provider.url", provider_url);
			} else {
				String errorMsg = "Rails database_configuration or System property java.naming.factory.initial did not contain initial factory, is jndi_context_factory set in database.yml?";
				log.fatal(errorMsg);
				throw new RuntimeException(errorMsg);
			}

		}
		
		Context initial_context = new InitialContext( properties );
		dataSource = ( DataSource )initial_context.lookup( jndi );
	}
	
	protected void buildDataSource( Map activeRecordConfig ) throws ClassNotFoundException {
		String driver = ( String )activeRecordConfig.get( "driver" );

    // XXX: hardcoded to mysql
    
		if ( driver == null ) {
			driver = "com.mysql.jdbc.Driver";
		}
				
		String url = ( String )activeRecordConfig.get( "url" );			
		if ( url == null) {
      StringBuilder buildUrl = new StringBuilder();
      
			buildUrl.append( "jdbc:mysql://" );
      String host = ( String )activeRecordConfig.get( "host" );
      if ( host == null ) {
        buildUrl.append( "localhost" );
      } else {
        buildUrl.append( host );
      }
      buildUrl.append( "/" );

      buildUrl.append( activeRecordConfig.get( "database" ) );

      // Setup autoReconnect for MySQL
      Object reconnect = activeRecordConfig.get( "reconnect" );
      if ( reconnect == null ) {
        reconnect = "true";
      }
      buildUrl.append("?autoReconnect=").append( !reconnect.toString().equals( "false" ) );
      
      url = buildUrl.toString();

      log.info( "JDBC url: " + url );
		}
		
		String username = ( String )activeRecordConfig.get( "username" );		
			
		String password = ( String )activeRecordConfig.get( "password" );
		
		DriverAdapterCPDS driver_adapter = new DriverAdapterCPDS();
		driver_adapter.setDriver( driver );
		driver_adapter.setUrl( url );
		driver_adapter.setPassword( password );
		driver_adapter.setUser( username );
	
		if ( log.isDebugEnabled() ) {
			log.debug( "Created DriverAdapterCPDS for [" + driver  + "] to [" + url + "]" );
		}
		
		SharedPoolDataSource sharedPool = new SharedPoolDataSource();
		sharedPool.setConnectionPoolDataSource( driver_adapter );
    sharedPool.setTestOnBorrow( true );
    sharedPool.setValidationQuery( "SELECT 1 FROM schema_migrations" );
		
		if ( log.isDebugEnabled() ) {
			log.debug( "Created SharedPoolDataSource" );
		}
		
		dataSource = sharedPool;
	}

	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
}
