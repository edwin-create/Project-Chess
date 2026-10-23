# frozen_string_literal: true

# Straight-line sliding movement.
module RookMovement
  def rook_moves # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    x, y = position
    potential_moves = []
    # Generate all potential moves in the horizontal and vertical direction
    (7 - y).times do |i|
      potential_moves << [x, y + i + 1]
    end
    y.times do |i|
      potential_moves << [x, y - i - 1]
    end
    (7 - x).times do |i|
      potential_moves << [x + i + 1, y]
    end
    x.times do |i|
      potential_moves << [x - i - 1, y]
    end
    potential_moves
  end
end
