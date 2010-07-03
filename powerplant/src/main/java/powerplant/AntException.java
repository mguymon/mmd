package powerplant;

/**
 * Exception form Ant
 *
 * @author Michael Guymon
 */
public class AntException extends Exception {

    /**
     * Creates a new instance of <code>AntException</code> without detail message.
     */
    public AntException() {
    }


    /**
     * Constructs an instance of <code>AntException</code> with the specified detail message.
     * @param msg the detail message.
     */
    public AntException(String msg) {
        super(msg);
    }

    public AntException( String msg, Throwable throwable ) {
      super( msg, throwable );
    }
}
