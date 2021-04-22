#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'

require_relative '../lib/word_count'

opt = OptionParser.new

params = { lines: false, words: false, bytes: false }
opt.on('-l') { |v| params[:lines] = v }
opt.on('-w') { |v| params[:words] = v }
opt.on('-c') { |v| params[:bytes] = v }
# オプション未指定の場合すべて表示
params = params.transform_values { true } unless params.value?(true)
opt.parse!(ARGV)

# 引数のパスに/*を入れた場合、ARGVからファイル名を配列で受け取る
paths = ARGV
pathnames = paths.size.zero? ? nil : paths.map { |path| Pathname(path) }.sort

# パスが指定されていない場合のみ標準入力を受け付ける
# パスが指定されている場合、パイプからの標準入力があっても無視される
input_text = $stdin.read unless pathnames

puts WordCount.new(pathnames, input_text, params).display
