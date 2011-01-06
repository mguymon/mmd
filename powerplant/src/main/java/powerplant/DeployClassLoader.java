package powerplant;

import java.net.URL;

public class DeployClassLoader extends ClassLoader {
    public DeployClassLoader() {
        super();
    }

    public DeployClassLoader( ClassLoader parent ) {
        super( parent );
    }

    protected Class loadClass(String name, boolean resolve) throws ClassNotFoundException {

        // First, check if the class has already been loaded
        Class clazz = findLoadedClass(name);

        // if not loaded, search the local (child) resources
        if (clazz == null) {
            try {
                clazz = findClass(name);
            } catch (ClassNotFoundException cnfe) {
                // ignore
            }
        }

        // If we could not find it, delegate to parent
        // Note that we do not attempt to catch any ClassNotFoundException
        if (clazz == null) {
            if (getParent() != null) {
                clazz = getParent().loadClass(name);
            } else {
                clazz = getSystemClassLoader().loadClass(name);
            }
        }

        // Resolve the class, if required
        if (resolve) {
            resolveClass(clazz);
        }

        return clazz;
    }

    /**
     * Override the parent-first resource loading model established by
     * java.land.Classloader with child-first behavior.
     *
     * @param name the name of the resource to load, should not be <code>null</code>.
     * @return a {@link URL} for the resource, or <code>null</code> if it could
     *         not be found.
     */
    public URL getResource(String name) {

        URL url = findResource(name);

        // If local search failed, delegate to parent
        if (url == null) {
            url = getParent().getResource(name);
        }

        return url;
    }


}
