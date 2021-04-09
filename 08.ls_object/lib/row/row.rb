# frozen_string_literal: true

module Row
  def display
    @units.last.reset_tab
    @units.map(&:display).join
  end


end
