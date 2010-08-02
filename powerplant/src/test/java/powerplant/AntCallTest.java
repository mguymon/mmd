package powerplant;

import java.io.IOException;
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
    AntCall instance = null;
    try {
      instance = new AntCall("target", "src/test/resources/build.xml", "target/test.log");
    } catch (IOException ex) {
      fail( "IO Error runnign AntCall: " + ex.toString() );
    }

    try {
      instance.runTask( task );
    } catch( Exception exception ) {
      fail( "Failed to run task: " + task + ", " + exception.toString() );
    }
  }
}
