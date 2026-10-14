# frozen_string_literal: true

# A shared base class for all chess pieces.
class Piece
  attr_reader :color, :position

  def initialize(color, position)
    @color = color
    @position = position
  end
end
