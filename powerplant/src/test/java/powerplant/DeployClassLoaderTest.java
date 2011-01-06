package powerplant;

import java.io.IOException;
import org.junit.Test;
import static org.junit.Assert.*;

public class DeployClassLoaderTest {

    @Test
    public void loadClass() throws IllegalAccessException, InstantiationException, ClassNotFoundException {
        DeployClassLoader classLoader = new DeployClassLoader();
        Class testClass = classLoader.loadClass( "powerplant.DuplicateProcessException" );

        assertEquals( DuplicateProcessException.class, testClass );
        DuplicateProcessException testObject = ( DuplicateProcessException )testClass.newInstance();

        assertNotNull( testObject );
    }
}
