module DbConfig
  def self.extended(base)
    base.class_exec do
      
      if ENV["RACK_ENV"] == "production"
        configure :production do
         db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')
         ActiveRecord::Base.establish_connection(
           :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
           :host     => db.host,
           :username => db.user,
           :password => db.password,
           :database => db.path[1..-1],
           :encoding => 'utf8'
         )
        end
      else
        set :database, {adapter: "sqlite3", database: "db.sqlite3"}
        set :show_exceptions, true
      end

    end
  end
end
