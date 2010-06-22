# == Synopsis
# 
# Deploy environment using Mighty Mighty Deployer, prompts for login, password
# and environment if options are not specified.
# 
# == Usage
# 
# runner [OPTIONS]
# 
# -h, --help:
#    show help
#
# -d, --debug:
#    run in debug mode
# 
# -l [login], --login [login]:
#    Mighty Mighty Deployer login
# 
# -p [pass], --password [pass]:
#    Mighty Mighty Deployer password
#
# -c [name], --client [name]:
#    The client short name to deploy
#
# -r [project], --project [name]:
#    The project short name to deploy
#
# -a [name], --application [name]:
#    The application short name to deploy
#
# -e [name], --environment [name]:
#    The environment short name to deploy
#    
# -m [url], --mmd_url [url]:
#    Specify the url of the Mighty Mighty Deployer. Defaults to https://maroon.igicom.com
#    
# -s, --show_production:
#    Show production environments in list
#
# -y, --yes:
#    Automatically accept deploy, do not prompt


require 'getoptlong'
require 'rdoc/ri/ri_paths'
require 'rdoc/usage'
require "highline/import"
require 'rexml/document'
require 'uri'
require 'net/http'
require 'net/https'   
 
HighLine.track_eof = false

opts = GetoptLong.new(
  [ '--help',            '-h', GetoptLong::NO_ARGUMENT ],
  [ '--debug',           '-d', GetoptLong::NO_ARGUMENT ],
  [ '--login',           '-l', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--password',        '-p', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--client',          '-c', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--project',         '-r', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--application',     '-a', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--environment',     '-e', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--environment_id',  '-E', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--mmd_url',         '-m', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--show_production', '-s', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--yes',             '-y', GetoptLong::NO_ARGUMENT ]
)

client = nil
clients = nil
project = nil
projects = nil
application = nil
applications = nil
environment = nil
environments = nil
environment_id = nil
login = nil
password = nil
mmd_url = 'https://maroon.igicom.com'
skip_prompt = false
is_production = false
is_running = false
@is_debug   = false
is_deploy = false
deploy_id = nil

opts.each do |opt, arg|
  case opt
  when '--help'
    RDoc::usage
  when '--debug'
    @is_debug = true
  when '--login'
    login = arg
  when '--password'
    password = arg
  when '--client'
    client = arg
  when '--project'
    project = arg
  when '--application'
    application = arg
  when '--environment'
    environment = arg
  when '--environment_id'
    environment_id = arg
  when '--mmd_url'
    mmd_url = arg
  when '--show_production'
    is_production = true
  when '--yes'
    skip_prompt = true
  end
end

if environment_id != nil
  if not environment.nil?
    say("ERROR: --environment_id cannot be used in conjuction with --environment (-e)")
  end
  if not application.nil?
    say("ERROR: --environment_id cannot be used in conjuction with --application (-a)")
  end
  if not project.nil?
    say("ERROR: --environment_id cannot be used in conjuction with --project (-r)")
  end
  if not client.nil?
    say("ERROR: --environment_id cannot be used in conjuction with --client (-c)")
  end
  exit 1
else
  if not environment.nil? and (application.nil? or project.nil? or client.nil?)
    say("ERROR: --environment cannot be used without --application (-a), --project (-r), and --client (-c)")
    exit 1
  else
    if not application.nil? and (project.nil? or client.nil?)
      say("ERROR: --application cannot be used without --project (-r), and --client (-c)")
      exit 1
    else
      if not project.nil? and client.nil?
        say("ERROR: --project cannot be used in conjuction with --client (-c)")
      end
    end
  end
end


def mmd_get( request_type, uri, cookie, params = {}, return_response = false )
  say("Connecting to get list of #{request_type}s")
  choices = {}
  http = Net::HTTP.new( uri.host, uri.port)
  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  response = nil
  http.start do |req|
    req.read_timeout = 300
    get = Net::HTTP::Get.new("/#{request_type}s.xml" )
    get.set_form_data( params )
    get.initialize_http_header({ 'cookie' => cookie })
    response = http.request(get).body
    if response =~ /<#{request_type}s type="array">/
      doc = REXML::Document.new( response )
      doc.elements.each("#{request_type}s/#{request_type}") do |ele|
        choices[ele.text('short-name')] = ele.text('id')
      end
    else
      say("ERROR: Mighty Mighty Deployer returned unexpected result")
      if @is_debug
        say(response)
      end
      exit 1
    end
  end

  choice = nil
  say( "Choose #{request_type}:" )
  choose do |menu|
    menu.select_by = :index_or_name

    choices.keys.each do |option|
      menu.choice option do |select| say( "  #{select} selected" ); choice = select  end
    end
  end

  return_response ? [choice, choices, response] : [choice, choices]
end

say("-------------------------------")
say("       Mini Mini Runner")
say("-------------------------------")

if login == nil
  login = ask("  Enter your login?  ")  { |q| q.validate = /\A\w+\Z/ }
end
    
if password == nil
  password = ask("  Enter your password:  ") { |q| q.echo = false }
end
    
uri = URI.parse( mmd_url )    

cookie = nil
http = Net::HTTP.new( uri.host, uri.port)    
if uri.scheme == 'https'
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end
http.start do |req|
  req.read_timeout = 300
  post = Net::HTTP::Post.new('/session.xml')
  post.set_form_data({'login'=>login, 'password'=>password})
  response = http.request(post)
  response_body =response.body
  cookie = response.response['set-cookie']
  if not response_body.include? 'success'
    say("ERROR: Mighty Mighty Deployer authenication failed.")
    exit 1
  else
    say( "  authenticated" )
  end
end

if environment_id == nil
  if client.nil?
    result = mmd_get( 'client', uri, cookie )
    clients = result[1]
    client = result[0]
  end

  if project.nil?
    result = mmd_get( 'project', uri, cookie, :client_id => clients[client] )
    projects = result[1]
    project = result[0]
  end

  if application.nil?
    result = mmd_get( 'app', uri, cookie, :project_id => projects[project] )
    applications = result[1]
    application = result[0]
  end

  if environment.nil?
    result = mmd_get( 'environment', uri, cookie,
      {:application_id => applications[application], :is_prodction => is_production}, true )
    environments = result[1]
    environment = result[0]
    environment_id = environments[environment]

    # Check to see if a deploy is already in progress
    doc = REXML::Document.new( result[2] )
    doc.elements.each("environments/environment") do |ele|
      if ele.text('id') == environment_id
        if ele.text('deploy-process/deploy/is-running') == 'true'
          is_running = true
          deploy_id = ele.text('deploy-process/deploy/id')
          break
        end
      end
    end
  else
    environments  = {}
    http = Net::HTTP.new( uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    response = nil
    http.start do |req|
      req.read_timeout = 300
      get = Net::HTTP::Get.new("/environments.xml" )
      get.set_form_data( {} )
      get.initialize_http_header({ 'cookie' => cookie })
      response = http.request(get).body
      if response =~ /<environments type="array">/
        doc = REXML::Document.new( response )
        doc.elements.each("environments/environment") do |ele|
          environments[ele.text('short-name')] = ele.text('id')
        end
      else
        say("ERROR: Mighty Mighty Deployer returned unexpected result")
        if @is_debug
          say(response)
        end
        exit 1
      end
    end

    environment_id = environments[environment]

    # Check to see if a deploy is already in progress
    doc = REXML::Document.new( response )
    doc.elements.each("environments/environment") do |ele|
      if ele.text('id') == environment_id
        if ele.text('deploy-process/deploy/is-running') == 'true'
          is_running = true
          deploy_id = ele.text('deploy-process/deploy/id')
          break
        end
      end
    end
  end
end

if not skip_prompt
  if is_running
    say( "Deploy to #{environment} as #{application} from #{project} for #{client} is already in progress." )
    say( "View the deploy already in progress?" )
  else
    say( "Deploy to #{environment} as #{application} from #{project} for #{client}?" )
  end
  choose do |menu|
    menu.select_by = :index_or_name
    choices = ['yes', 'no']
    choices.each do |option|
      menu.choice option do |select| say( "  #{select} selected" ); is_deploy = (select == 'yes')  end
    end
  end
else
  is_deploy = true
end

if !is_deploy
  say( "exiting" )
  exit 1
else
  say( "--= Begin Progress Log =--")

  log_end = 0
  if not is_running
    http = Net::HTTP.new( uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    http.start do |req|
      req.read_timeout = 300
      post = Net::HTTP::Post.new('/deploys.xml')
      post.initialize_http_header({ 'cookie' => cookie })
      post.set_form_data({'environment_id' => environment_id, 'deployed_by' => login})

      result = http.request(post).body
      if result =~ /<deploy>/
        doc = REXML::Document.new( result )

        doc.elements.each('deploy/progressive_log') do |ele|
          if ele.has_text?
            log = ele.text
            if not @is_debug
              log = log.gsub( /\[DEBUG\] .+\n|\r/, "" )
            end
            say( log )
          end
        end

        doc.elements.each('deploy/is-running') do |ele|
          if ele.text == 'true'
            is_running = true
          else
            doc.elements.each('deploy/note') do |ele|
              if ele.has_text?
                say( "Deploy finished with note: #{ele.text}")
              end
            end
          end
        end

        doc.elements.each('deploy/id') do |ele|
          deploy_id = ele.text
        end

        doc.elements.each('deploy/log_end') do |ele|
          log_end = ele.text
        end
      else
        say("ERROR: Mighty Mighty Deployer returned unexpected result")
        if @is_debug
          say(result)
        end
        exit 1
      end
    end
  end
  
  sleep_seconds = 5
  if is_running
    http = Net::HTTP.new( uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    http.start do |req|
      req.read_timeout = 300
      while is_running

        get = Net::HTTP::Get.new("/deploys/#{deploy_id}.xml?start=#{log_end}")
        get.initialize_http_header({ 'cookie' => cookie })
        result = http.request(get).body
        if result =~ /<deploy>/
          doc = REXML::Document.new( result )

          doc.elements.each('deploy/progressive_log') do |ele|
            log = ele.text
            if log
              if not @is_debug
                log = log.gsub( /\[DEBUG\] .+?\n|\r/, "" )
              end
              say( log )
            end
          end

          doc.elements.each('deploy/log_end') do |ele|
            if ele.text == log_end
              sleep_seconds = sleep_seconds * 1.2
              if sleep_seconds > 10
                sleep_seconds = 10
              end
            else
              sleep_seconds = 5
            end
            log_end = ele.text
          end

          doc.elements.each('deploy/is-running') do |ele|
            if ele.text != 'true'
              is_running = false
              doc.elements.each('deploy/note') do |ele|
                if ele.has_text?
                  say( "Deploy finished with note: #{ele.text}")
                end
              end

              doc.elements.each('deploy/is-success') do |ele|
                if ele.has_text? and ele.text == "false"
                  exit 1
                end
              end

            end
          end

          sleep sleep_seconds
        else
          say("ERROR: Mighty Mighty Deployer returned unexpected result")
          if @is_debug
            say(result)
          end
          exit 1
        end
      end
    end
  end

  say( "--= End Progress Log =--")
  say( "" )
  say( "Deploy finished" )
end
