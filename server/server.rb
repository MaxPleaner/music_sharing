require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'sinatra/base'
require "sinatra/activerecord"
require 'faye/websocket'
require 'byebug'
require 'sinatra_auth_github'
require('dotenv'); Dotenv.load
require 'sinatra/cross_origin'
require 'active_support/all'
require './crud_generator'
require './server_push'
require './models'
require './ws'
require './db_config'
require './embed_url'
Sockets = Set.new

ServerToken = SecureRandom.urlsafe_base64

CLIENT_BASE_URL = if ENV["RACK_ENV"] == "production"
  "https://maxpleaner.github.io"
else
  "http://localhost:8080"
end

class Server < Sinatra::Base

  set :server, 'thin'
  Faye::WebSocket.load_adapter('thin')

  register Sinatra::ActiveRecordExtension

  register Sinatra::CrossOrigin
  
  register Sinatra::CrudGenerator

  extend DbConfig

  post '/authenticate' do
    cross_origin allow_origin: CLIENT_BASE_URL
    puts "PARAMS: #{params}"
    if params[:pass]&.eql?(ENV.fetch "PASS")
      ServerToken
    else
      status 401
    end
  end

  get '/health' do
    cross_origin allow_origin: CLIENT_BASE_URL
    status 200
  end

  get '/ws' do
    Ws.run(request)
  end

  auth = Proc.new do |request|
    if request.params["server_token"] == ServerToken
      puts "ALL GOOD"
      nil
    else
      { error: "invalid token" }.to_json
    end
  end

  crud_generate(
    auth: auth,
    resource: "audio",
    resource_class: Audio,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
    except: [:update],
    secure_params: Proc.new do |request|
      %w{ source url video_id }
    end
  )

  # Tags are created/destroyed through hooks on the tagging model
  # They are only indexed here
  crud_generate(
    auth: auth,
    resource: "tag",
    resource_class: Tag,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
    except: [:update, :destroy, :create]
  )

  crud_generate(
    auth: auth,
    resource: "comment",
    resource_class: Comment,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
  )

  crud_generate(
    auth: auth,
    resource: "tagging",
    resource_class: Tagging,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
    except: [:update],
    secure_params: Proc.new do |request|
      %w{ name audio_id }
    end
  )

end
