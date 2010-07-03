package powerplant;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Michael Guymon
 */
public class AntCallTest {

  public AntCallTest() {
  }

  /**
   * Test of runTask method, of class AntCall.
   */
  @Test
  public void testRunTask() {
    String task = "test";
    AntCall instance = new AntCall( "src/test/resources/build.xml" );

    try {
      instance.runTask( task );
    } catch( Exception exception ) {
      fail( "Failed to run task: " + task + ", " + exception.toString() );
    }
  }
}
