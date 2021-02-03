#!/usr/bin/env ruby
# frozen_string_literal: true

def run_app(pathnames, input_text, params)
  result = []
  total = { name: 'total' }
  params.keys.each { |key| total[key] = 0 if params[key] }

  if pathnames
    # ファイルパス引数あり
    file_paths = Dir.glob(pathnames).sort
    if file_paths.size.zero?
      result << { no_file: "wc: #{pathnames[0]}: open: No such file or directory" } 
    else
      count_file_content(file_paths, result, total, params)
    end
  else
    # パスの引数がない場合は標準入力のテキスト
    text_data = {}
    count_content(text_data, input_text, **params)
    result << text_data
  end

  # 結果が複数の場合はtotal表示追加
  result << total if result.size >= 2
  result.map { |r| align_data(r, params) }.join("\n")
end

def count_file_content(file_paths, result, total, params)
  file_paths.each do |file_path|
    text_data = { name: file_path }
    if File.stat(file_path).ftype == 'directory'
      text_data[:directory] = "wc: #{file_path}: read: Is a directory"
      params.keys.each { |key| text_data[key] = 0 if params[key] }
    else
      text = File.read(file_path)
      count_content(text_data, text, **params)
    end
    params.keys.each { |key| total[key] += text_data[key] if params[key] }
    result << text_data
  end
end

def count_content(text_data, text, lines: false, words: false, bytes: false)
  text_data[:lines] = text.count("\n") if lines
  text_data[:words] = text.split(' ').count if words
  text_data[:bytes] = text.bytesize if bytes
end

def align_data(text_data, params)
  return text_data[:directory] if text_data[:directory]
  return text_data[:no_file] if text_data[:no_file]

  aligned = ''
  params.keys.each { |key| aligned += text_data[key].to_s.rjust(8) if params[key] }
  aligned += text_data[:name] ? " #{text_data[:name]}" : ''
end
