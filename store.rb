def wirte_file(site, txt)
  timestamp = Time.now
  open("creds/#{ site }/#{ site }.txt", 'a') do |f|
    msg = "#{ timestamp }: #{ txt }"
    f.puts msg
  end
end