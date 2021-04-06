# frozen_string_literal: true

require_relative 'row'

class FileList
  def initialize(path, params)
    items = Dir.foreach(path || '.').to_a

    # l ? list_detail(path, files) : list_name(files)
    @files = apply_order_option(items, params[:a], params[:r])
    # return if @files.size.zero?
  end

  def apply_order_option(items, a_opt, r_opt)
    # Debian10/bash では'.'及び大文字小文字は無視してソートする
    files = items.sort { |a, b| a.gsub(/^\./, '').downcase <=> b.gsub(/^\./, '').downcase }
    # -a オプション
    files.delete_if { |f| f.match?(/^\..*/) } unless a_opt
    # -r オプション
    files.reverse! if r_opt

    files
  end

  def display
    @files.join("\t")
  end
end
