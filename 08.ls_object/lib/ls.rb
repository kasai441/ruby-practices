#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'list_files'

params = { a: false, r: false, l: false }
opt = OptionParser.new
opt.on('-a') { params[:a] = true }
opt.on('-r') { params[:r] = true }
opt.on('-l') { params[:l] = true }
opt.parse!(ARGV)

disp = ListFiles.new(ARGV[0], params).display
puts disp unless disp.nil?
