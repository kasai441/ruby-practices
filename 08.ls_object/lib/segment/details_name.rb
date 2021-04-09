# frozen_string_literal: true

require_relative 'name'

class Segment::DetailsName < Segment::Name
  def display
    SPACE_STRING * @space + @name
  end

  def need_space(_)
    1
  end
end
