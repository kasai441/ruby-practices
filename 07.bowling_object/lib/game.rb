# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(scores)
    @frames = []
    @scores = scores
    frame_index = 0
    frame = Frame.new(frame_index)

    scores.each_with_index do |s, i|
      frame.roll(s, i)
      next unless frame.fix?

      @frames << frame
      frame_index += 1
      frame = Frame.new(frame_index)
    end
  end

  def score
    @frames.map(&:score).sum + bonus
  end

  private

  def bonus
    @frames.map do |f|
      if f.strike?
        index = f.index_strike
        @scores[index + 1] + @scores[index + 2]
      elsif f.spare?
        index = f.index_spare
        @scores[index + 1]
      else
        0
      end
    end.sum
  end
end
