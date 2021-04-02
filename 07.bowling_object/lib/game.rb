# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_accessor :frames

  def initialize(scores)
    @frames = []
    frame = Frame.new
    frame_num = 0
    p scores
    p scores.sum
    scores.each do |s|
      frame.last if frame_num == 9
      frame.roll(s)
      next unless frame.fix?

      @frames << frame
      frame = Frame.new
      frame_num += 1
    end
  end

  def score
    @frames.map(&:score).sum
  end
end
