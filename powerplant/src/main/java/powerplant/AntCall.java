package powerplant;

import java.io.File;

// Apache Ant
import java.io.IOException;
import java.util.Map;
import org.apache.log4j.Logger;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;
import org.apache.tools.ant.listener.Log4jListener;

/**
 * Call Ant tasks
 *
 * @author Michael Guymon
 */
public class AntCall {

  private String buildXML;
  private String baseDir;
  private Logger log;

  public AntCall( String baseDir, String buildXML, String logFile ) throws IOException {
    this.baseDir = baseDir;
    this.buildXML = buildXML;

    log = LogHelper.getLog( this.getClass(), logFile );
  }
  
  public void runTask( String task ) throws AntException {
    runTask( task, null );
  }

  public void runTask( String task, Map parameters ) throws AntException {
    File buildFile = new File( this.buildXML );
    File buildDir = new File( this.baseDir );
    Project project = new Project();
    try {
      project.setBaseDir( buildDir );
      project.addBuildListener( new Log4jListener() );
      project.setUserProperty("ant.file", buildFile.getAbsolutePath());

      if ( parameters != null ) {
        for ( Object key : parameters.keySet() ) {
          Object val = parameters.get( key );
          if ( val != null ) {
            log.debug( "Setting property " + key.toString() + " to " + val.toString() );
            project.setUserProperty( key.toString(), val.toString() );
          }
        }
      }

      project.init();
      ProjectHelper helper = ProjectHelper.getProjectHelper();
      project.addReference("ant.projectHelper", helper);
      helper.parse(project, buildFile);
      project.executeTarget( task );
      project.fireBuildFinished(null);

    } catch (BuildException buildException) {
      log.error( "Failed to execute task " + task + " " + buildException.toString(), buildException );
      project.fireBuildFinished( buildException );

      throw new AntException( "Failed to execute task " + task, buildException );
    }
  }
}
