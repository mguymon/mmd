#require "java"
#module JavaIO
#  include_package "java.io"
#end
#module JavaUtil
#  include_package "java.util"
#end
#include_class "org.tmatesoft.svn.core.wc.ISVNOptions"
#include_class "org.tmatesoft.svn.core.wc.SVNClientManager"
#include_class "org.tmatesoft.svn.core.wc.SVNRevision"
#include_class "org.tmatesoft.svn.core.SVNURL"
#include_class "org.tmatesoft.svn.core.internal.io.fs.FSRepositoryFactory"
#include_class "org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory"
#include_class "org.tmatesoft.svn.core.internal.io.svn.SVNRepositoryFactoryImpl"
#include_class "org.tmatesoft.svn.core.auth.SVNPasswordAuthentication"
#include_class "org.tmatesoft.svn.core.auth.BasicAuthenticationManager"


class SubversionUtil

  def initialize(username=nil, password=nil)
    @username = username
    @password = password
#    authManager = nil
#    if username and password
#      auth =
#        SVNPasswordAuthentication.new( username, password, false);
#      authManager = BasicAuthenticationManager.new( [auth].to_java(SVNPasswordAuthentication) )
#    end
#
#    options = ISVNOptions.new()
#    @client_manager = SVNClientManager.newInstance(options, authManager);
#
#    # FIXME: HARDCODED for all repos
#    DAVRepositoryFactory.setup()
#    FSRepositoryFactory.setup()
#    SVNRepositoryFactoryImpl.setup()
  end
    
  def export(from_url, to_file, options = { :rev => 'HEAD', :peg_rev => 'UNDEFINED', :force => false, :recursive => true, :native_eol => 'native' } )
#    svn_from_url = SVNURL.parseURIEncoded(from_url)
#    svn_to_file = JavaIO::File.new(to_file)
#    svn_rev = nil
#    if options[:rev] != 'HEAD'
#      svn_rev = SVNRevision.create(Integer(options[:rev]))
#    else
#      svn_rev = SVNRevision::HEAD
#    end
#
#    peg_rev = nil
#    if options[:peg_rev] != 'UNDEFINED'
#      peg_rev = SVNRevision.create(Integer(options[:peg_rev]))
#    else
#      peg_rev = SVNRevision::UNDEFINED
#    end
#
#    @client_manager.getUpdateClient().doExport(
#      svn_from_url,
#      svn_to_file,
#      peg_rev,
#      svn_rev,
#      options[:native_eol],
#      options[:force],
#      options[:recursive])

    `svn export #{from_url} #{to_file} #{"--username #{@username}" if @username} #{"--password #{@password}" if @password}` #-r #{options[:rev]} #{'--force' if options[:force] == true}`
  end
  
end