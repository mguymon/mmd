package powerplant;

import java.io.File;
import java.io.IOException;
import org.apache.log4j.Logger;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Michael Guymon
 */
public class LogHelperTest {

  @Test
  public void testCreateNewLogger() {
    Logger log = null;
    String log_file = "target/log_helper_test1.log";

    File file = new File(log_file);
    if ( file.exists() ) {
      file.delete();
    }

    try {
      log = LogHelper.getLog(this.getClass(), log_file);
    } catch (IOException ex) {
      fail( "Failed to create log file: " + ex.toString() );
    }

    assertNotNull( log );

    log.error( "Hello World" );

    assertTrue( file.exists());

    log_file = "target/log_helper_test2.log";

    file = new File(log_file);
    if ( file.exists() ) {
      file.delete();
    }

    try {
      log = LogHelper.getLog(this.getClass(), log_file);
    } catch (IOException ex) {
      fail( "Failed to create log file: " + ex.toString() );
    }

    assertNotNull( log );

    log.error( "Hello World again" );

    assertTrue( file.exists());
  }

}
