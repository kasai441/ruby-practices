# frozen_string_literal: true

class PathStats < Stats
  def initialize(path, params)
    @path = path
    text = File.read(@path) unless directory?
    super(text, **params)
  end

  def display
    if directory?
      "wc: #{@path}: read: Is a directory"
    else
      super + " #{@path}"
    end
  end

  def values
    if directory?
      @params.keys.map { |key| 0 if @params[key] }.compact
    else
      super
    end
  end

  def directory?
    @path && File.stat(@path).ftype == 'directory'
  end
end
