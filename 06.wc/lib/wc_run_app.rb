#!/usr/bin/env ruby
# frozen_string_literal: true

#require 'pathname'

def run_app(pathnames, input_data, lines: false, words: false, bytes: false)
  result = []
  total = { name: 'total' }
  total[:lines] = 0 if lines
  total[:words] = 0 if words
  total[:bytes] = 0 if bytes

  if pathnames
    file_counts(pathnames, result, total, lines, words, bytes)
  else
    text_data = {}
    counts(text_data, input_data, lines, words, bytes)
    result << text_data
  end

  result << total if result.size >= 2
  result.map { |f| align_data(f) }.join("\n")
end

def file_counts(pathnames, result, total, lines, words, bytes)
  file_paths = Dir.glob(pathnames).sort
  file_paths.each do |file_path|
    text_data = {}
    if directory?(file_path)
      text_data[:directory] = "wc: #{file_path}: read: Is a directory"
      text_data[:lines] = 0 if lines
      text_data[:words] = 0 if words
      text_data[:bytes] = 0 if bytes
    else
      text = File.read(file_path)
      counts(text_data, text, lines, words, bytes)
    end
    total[:lines] += text_data[:lines] if lines
    total[:words] += text_data[:words] if words
    total[:bytes] += text_data[:bytes] if bytes

    text_data[:name] = file_path
    result << text_data
  end
end

def counts(text_data, text, lines, words, bytes)
  text_data[:lines] = text.count("\n") if lines
  text_data[:words] = text.split(' ').count if words
  text_data[:bytes] = text.bytesize if bytes
end

def directory?(file_path)
  # File.statにシンボリックリンクのパスを入れると例外となる
  # その場合異常終了とする
  File.stat(file_path).ftype == 'directory'
end

def align_data(text_data)
  aligned = ''
  return text_data[:directory] if text_data[:directory]
  aligned += text_data[:lines] ? text_data[:lines].to_s.rjust(8) : ''
  aligned += text_data[:words] ? text_data[:words].to_s.rjust(8) : ''
  aligned += text_data[:bytes] ? text_data[:bytes].to_s.rjust(8) : ''
  aligned += text_data[:name] ? " #{text_data[:name]}" : ''
end
