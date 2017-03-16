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

Sockets = Set.new

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

  get '/health' do
    cross_origin allow_origin: CLIENT_BASE_URL
    status 200
  end

  get '/ws' do
    Ws.run(request)
  end

  crud_generate(
    resource: "audio",
    resource_class: Audio,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
    except: [:update, :destroy],
    secure_params: Proc.new do |request|
      %w{ source url video_id }
    end
  )

  crud_generate(
    resource: "tag",
    resource_class: Tag,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
    except: [:update, :destroy]
  )

  crud_generate(
    resource: "comment",
    resource_class: Comment,
    cross_origin_opts: { allow_origin: CLIENT_BASE_URL },
    except: [:update, :destroy]
  )

end
