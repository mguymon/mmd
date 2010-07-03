package powerplant;

import java.io.File;

// Apache Common Logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

// Apache Ant
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

  private Log log = LogFactory.getLog( this.getClass() );
  private String buildXML;

  public AntCall( String buildXML ) {
    this.buildXML = buildXML;
  }

  public void runTask( String task ) throws AntException {
    File buildFile = new File( this.buildXML );
    Project project = new Project();
    try {
      project.addBuildListener( new Log4jListener() );
      project.setUserProperty("ant.file", buildFile.getAbsolutePath());
      project.init();
      ProjectHelper helper = ProjectHelper.getProjectHelper();
      project.addReference("ant.projectHelper", helper);
      helper.parse(project, buildFile);
      project.executeTarget( task );
      project.fireBuildFinished(null);

    } catch (BuildException buildException) {
      log.error( "Failed to execute task " + task, buildException );
      project.fireBuildFinished( buildException );

      throw new AntException( "Failed to execute task " + task, buildException );
    }
  }
}
