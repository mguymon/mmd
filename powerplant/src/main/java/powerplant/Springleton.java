package powerplant;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Singleton to access the Spring context
 * 
 * @author Michael Guymon
 *
 */
public class Springleton {
	private static ApplicationContext applicationContext;
		
	public synchronized static void loadApplicationContext() {		
		applicationContext = new ClassPathXmlApplicationContext( new String[] { "applicationContext.xml", "applicationContext-datasource.xml" } );		
	}
	
	public static ApplicationContext getApplicationContext() {		
		return applicationContext;
	}
}
