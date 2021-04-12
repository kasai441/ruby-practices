#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative '../lib/list_segments'

params = { a: false, r: false, l: false }
opt = OptionParser.new
opt.on('-a') { params[:a] = true }
opt.on('-r') { params[:r] = true }
opt.on('-l') { params[:l] = true }
opt.parse!(ARGV)

stats = %i[type size name]

disp = ListSegments.new(ARGV[0], params, stats).display
puts disp unless disp.nil?
