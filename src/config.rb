#TODO

require 'ostruct'

Config = OpenStruct.new 

Config.hotreload_check_time = 2 # second

Config.restore_state = true
Config.restore_actions = true

Config.log_requests = true