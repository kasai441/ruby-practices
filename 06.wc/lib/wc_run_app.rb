#!/usr/bin/env ruby
# frozen_string_literal: true

#require 'pathname'

def run_app(pathnames, input_data, lines: false, words: false, bytes: false)
  file_paths = Dir.glob(pathnames) if pathnames
  result = []
  p pathnames

  p file_paths
  file_paths.each do |file_path|
    file_data = {}
    if directory?(file_path)
      file_data[:directory] = "wc: #{file_path}: Is a directory\n"
      file_data[:lines] = '0'
      file_data[:words] = '0'
      file_data[:bytes] = '0'
    else
      file = File.read(file_path)
      file_data[:lines] = count_lines(file) if lines
      file_data[:words] = count_words(file) if words
      file_data[:bytes] = count_bytes(file_path) if bytes
    end
    file_data[:name] = file_path
    result << align_data(file_data)
  end
  p result.join("\n")
    '   6      28     227 test/fixtures/sample/Rakefile'
  result.join("\n")
end

def directory?(file_path)
  File.stat(file_path).ftype == 'directory'
end

def count_lines(file)
  file.count("\n").to_s
end

def count_words(file)
  file.split(' ').count.to_s
end

def count_bytes(file_path)
  File.stat(file_path).size.to_s
end

def align_data(file_data)
  aligned = ''
  aligned += file_data[:directory] ? file_data[:directory] : ''
  aligned += file_data[:lines] ? file_data[:lines].rjust(8) : ''
  aligned += file_data[:words] ? file_data[:words].rjust(8) : ''
  aligned += file_data[:bytes] ? file_data[:bytes].rjust(8) : ''
  aligned += file_data[:name] ? " #{file_data[:name]}" : ''
end
