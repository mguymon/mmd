# #!/usr/bin/env jruby
 
#  Copyright 2007 Michael Guymon
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# 
# Checks the jruby-velocity POM xml over the web for jar dependencies, downloads
# them to the lib directory if they do not exist, and load them into the
# classpath
# 
require 'net/http'
require 'rexml/document'
require 'log4r'

# A Jar Depedency
class JarDependency  
    attr_accessor :groupId, :artifactId, :version, :scope, :url, :jar_file
    
    def to_s
        return "#{@groupId} #{artifactId} #{version} #{scope} #{url} #{jar_file}"
    end
end

class Maven

    def initialize
        # create a logger named 'mylog' that logs to stdout
        @logger = Log4r::Logger.new( 'maven' )

        # You can use any Outputter here.
        @logger.outputters = Log4r::Outputter.stdout

        # Open a new file logger
        file_output = Log4r::FileOutputter.new('fileOutputter', :filename => 'maven.log',:trunc => false)
        format = Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m")
        file_output.formatter = format
        @logger.add( file_output )
        
        # DEBUG < INFO < WARN < ERROR < FATAL
        @logger.level = Log4r::DEBUG
    end
    
    def loadDependencies( url_or_path_to_pom )
        # Default Maven repo url
        defaultMavenUrl = 'http://repo1.maven.org/maven2'
             
        xml_data = ""
        if url_or_path_to_pom =~ /^http/                        
            @logger.debug( 'loading pom from url' )  
            # get the XML data as a string
            xml_data = Net::HTTP.get_response( URI.parse( path_to_pom ) ).body
        else
            @logger.debug( 'loading pom from path' )  
            file = File.new( url_or_path_to_pom, "r")            
            file.read( nil, xml_data )
            file.close
        end
        # extract event information
        doc = REXML::Document.new(xml_data)
        
        # jar dependencies array
        dependencies = []      

        # iterator through the POM's jar depedencies
        doc.elements.each('project/dependencies/dependency') do |dependency|
            jar_dep = JarDependency.new()
            dependency.elements.each do |ele| 
                jar_dep.instance_variable_set( "@#{ele.name}", ele.text.strip )       
            end

            # testing jars and the jruby jar are not required
            if jar_dep.scope != "test" and jar_dep.groupId != "org.jruby"
                # build the jar url
                jar_dep.jar_file = "#{jar_dep.artifactId}-#{jar_dep.version}.jar"
                jar_dep.url = "#{defaultMavenUrl}/#{jar_dep.groupId.sub( /[.]/, '/' )}/#{jar_dep.artifactId}/#{jar_dep.version}"

                # add to the dependency array
                dependencies << jar_dep
            end
        end

        # 
        # Check that all the jars are in the lib/java dir, if not, download. Add
        # jars to the classpath.
        # 
        dependencies.each do | jar_dep |
            jar_path = "#{File.dirname(__FILE__)}/../lib/java/#{jar_dep.jar_file}"
            if not File.exists?( jar_path )
                @logger.info "Downloading #{jar_dep.jar_file} from #{jar_dep.url} to #{jar_path}\n"
                jar_data = Net::HTTP.get( URI.parse("#{jar_dep.url}/#{jar_dep.jar_file}") )
                jar_file = File.new( jar_path, "w" )
                jar_file.syswrite( jar_data )
                @logger.info "Success.\n"        
            end    
            require jar_path
        end
    end
end