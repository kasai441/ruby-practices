#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'file_list'

params = { a: false, r: false, l:false }
opt = OptionParser.new
opt.on('-a') { params[:a] = true }
opt.on('-r') { params[:r] = true }
opt.on('-l') { params[:l] = true }
opt.parse!(ARGV)

path = ARGV[0]

puts FileList.new(path, params).display
