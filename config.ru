require './rphish'

set :environment, :production if ENV['APP_ENV'] == 'production'
run Rack::URLMap.new({
  '/' => Public
})
