#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require "socket"
require "date"
require 'yaml'
require 'fileutils'

$server_addr = '127.0.0.1'
$server_port = '55555'
$target_addr = '127.0.0.1'

$root = File.expand_path('..')
$bin_root = $root + '/bin'
$data_root = $root + '/data'
$result_root = $root + '/result'


class Generator
	def initialize( opt = {} )
		@bin_save_dir = $data_root + '/binary/' + Time.now.strftime("%Y%m%d_%H%M%S")
		FileUtils.mkdir_p(@bin_save_dir)
	end
	
	def executeTest()
		scenario_file = $data_root + "/scenario/scenario.yaml"
		all_data = YAML.load_file(scenario_file)

		all_scenario = all_data['scenario']
		all_scenario.each {|s|
			s['name'] = all_data['common']['name']
			data = YAML.dump(s)
			executeJob(data)
			collectResult(s)
		}
	end

	def executeJob( send_data )
		TCPSocket.open($server_addr, $server_port) {|client|
			# req
			client.write(send_data)
			client.flush
			# ack
			recv_data = client.recv(65536)
			p recv_data
		}
	end

	def collectResult( scenario )
	end
end

class Sender
	def initialize( opt = {} )
		@bin_save_dir = opt[:bindir]
		@result_dir = $result_root + '/' + Time.now.strftime("%Y%m%d_%H%M%S")
		FileUtils.mkdir_p(@result_dir)
	end
	
	def executeTest()
		Dir.glob(@bin_save_dir + "/*.dat").each {|f|
			executeJob(f)
			collectResult(f)
		}
	end

	def executeJob( bin_file )
		cmd = "lpr -S #{$target_addr} -P lp bin_file"
		p cmd
		#system(cmd)
	end

	def collectResult( f )
		dst_dir = @result_dir + '/' + File.basename(f)
		FileUtils.mkdir_p(dst_dir)
		FileUtils.cp(f, dst_dir)
	end
end


case ARGV[0]
when '1'
	binGenerator = Generator.new()
	binGenerator.executeTest()
when '2'
	opt = { :bindir => $data_root + '/binary/20160502_203526' }
	binSender = Sender.new(opt)
	binSender.executeTest()
else
	puts "?????"
end
