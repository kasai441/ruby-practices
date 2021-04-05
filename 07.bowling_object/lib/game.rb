# frozen_string_literal: true

require_relative 'frame'

class Game
  MAX_FRAME = 9

  def initialize(scores)
    @scores = scores
    @frames = []
    frame_index = 0
    frame = Frame.new(frame_index, MAX_FRAME)

    scores.each_with_index do |s, i|
      frame.roll(s, i)
      if frame.fix?
        @frames << frame
        frame_index += 1
        frame = Frame.new(frame_index, MAX_FRAME)
      elsif @frames.size > MAX_FRAME
        @frames << 'an exceeding frame'
        break
      end
    end
  end

  def error_message
    max = MAX_FRAME + 1
    if @frames.size < max
      "不正スコア：#{max}フレーム未満のスコアです"
    elsif @frames.size > max
      "不正スコア：#{max}フレームを超えるスコアです"
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
