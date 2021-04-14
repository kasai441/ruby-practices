#!/usr/bin/env ruby
# frozen_string_literal: true

def run_app(pathnames, input_text, params)
  result = []
  if pathnames
    # ファイルパス引数あり
    file_paths = Dir.glob(pathnames).sort
    if file_paths.size.zero?
      result << { no_file: "wc: #{pathnames[0]}: open: No such file or directory" }
    else
      count_file_content(file_paths, result, params)
    end
  else
    # パスの引数がない場合は標準入力のテキスト
    text_data = {}
    count_content(text_data, input_text, **params)
    result << text_data
  end

  result.map { |r| align_data(r, params) }.join("\n")
end

def count_file_content(file_paths, result, params)
  total = init_total(params)
  file_paths.each do |file_path|
    text_data = { name: file_path }
    if File.stat(file_path).ftype == 'directory'
      write_directory(text_data, file_path, params)
    else
      write_file(text_data, file_path, params)
    end
    params.each_key { |key| total[key] += text_data[key] if params[key] }
    result << text_data
  end
  # 結果が複数の場合はtotal表示追加
  result << total if result.size >= 2
end

def init_total(params)
  total = { name: 'total' }
  params.each_key { |key| total[key] = 0 if params[key] }
  total
end

def write_directory(text_data, file_path, params)
  text_data[:directory] = "wc: #{file_path}: read: Is a directory"
  params.each_key { |key| text_data[key] = 0 if params[key] }
end

def write_file(text_data, file_path, params)
  text = File.read(file_path)
  count_content(text_data, text, **params)
end

def count_content(text_data, text, lines: false, words: false, bytes: false)
  text_data[:lines] = text.count("\n") if lines
  text_data[:words] = text.strip.split(/[\s　]+/).count if words
  text_data[:bytes] = text.bytesize if bytes
end

def align_data(text_data, params)
  return text_data[:directory] if text_data[:directory]
  return text_data[:no_file] if text_data[:no_file]

  aligned = ''
  params.each_key { |key| aligned += text_data[key].to_s.rjust(8) if params[key] }
  aligned += text_data[:name] ? " #{text_data[:name]}" : ''
end
