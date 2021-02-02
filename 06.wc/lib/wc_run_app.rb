#!/usr/bin/env ruby
# frozen_string_literal: true

#require 'pathname'

def run_app(pathnames, input_data, lines: false, words: false, bytes: false)
  file_paths = Dir.glob(pathnames).sort if pathnames
  file_list = []
  total = { lines: 0, words: 0, bytes: 0, name: 'total' }

  file_paths.each do |file_path|
    file_data = {}
    if directory?(file_path)
      file_data[:directory] = "wc: #{file_path}: read: Is a directory"
      file_data[:lines] = 0 if lines
      file_data[:words] = 0 if words
      file_data[:bytes] = 0 if bytes
    else
      file = File.read(file_path)
      file_data[:lines] = file.count("\n") if lines
      file_data[:words] = file.split(' ').count if words
      file_data[:bytes] = File.stat(file_path).size if bytes
    end
    total[:lines] += file_data[:lines] if lines
    total[:words] += file_data[:words] if words
    total[:bytes] += file_data[:bytes] if bytes

    file_data[:name] = file_path
    file_list << file_data
  end
  file_list << total if file_list.size >= 2
  file_list.map { |f| align_data(f) }.join("\n")
end

def directory?(file_path)
  # File.statにシンボリックリンクのパスを入れると例外となる
  # その場合File.lstatにパスを入れる
  # File.lstatで例外となる場合異常終了とする
  File.stat(file_path).ftype == 'directory'
rescue SystemCallError
  File.lstat(file_path)
end

def align_data(file_data)
  aligned = ''
  return file_data[:directory] if file_data[:directory]
  aligned += file_data[:lines] ? file_data[:lines].to_s.rjust(8) : ''
  aligned += file_data[:words] ? file_data[:words].to_s.rjust(8) : ''
  aligned += file_data[:bytes] ? file_data[:bytes].to_s.rjust(8) : ''
  aligned += file_data[:name] ? " #{file_data[:name]}" : ''
end
