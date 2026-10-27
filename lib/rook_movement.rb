# frozen_string_literal: true

# Straight-line sliding movement.
module RookMovement
  def rook_moves # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    row, col = position
    potential_moves = []
    # Generate all potential moves in the horizontal and vertical direction
    (7 - col).times do |i|
      potential_moves << [row, col + i + 1]
    end
    (7 - row).times do |i|
      potential_moves << [row + i + 1, col]
    end
    col.times do |i|
      potential_moves << [row, col - i - 1]
    end
    row.times do |i|
      potential_moves << [row - i - 1, col]
    end
    potential_moves
  end
end
