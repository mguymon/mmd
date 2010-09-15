package powerplant;

import java.io.IOException;
import org.apache.log4j.FileAppender;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;

/**
 *
 * @author Michael Guymon
 */
public class LogHelper {

  /**
   * Returns a Log4J {@link Logger} with the Thread ID appended to the class
   * name. This ensures a unique Logger instance, which will log to the logFile.
   *
   * @param clazz
   * @param logFile
   * @return {@link Logger}
   * @throws IOException
   */
  public static Logger getLog( Class clazz, String logFile ) throws IOException {

    Logger log = Logger.getLogger( clazz.getName() + "["+ Thread.currentThread().getId() + "]" );
    log.removeAllAppenders();

    log.addAppender(
      new FileAppender( new PatternLayout("%d [%5p] (%c{3}:%M) - %m%n"), logFile ) );

    return log;
  }

}
