# frozen_string_literal: true

require_relative 'piece'
# Diagonal sliding movement.
class Bishop < Piece
  def valid_moves # rubocop:disable Metrics/AbcSize
    x, y = position
    potential_moves = []
    # Generate all potential moves in the diagonal direction
    7.times do |i|
      potential_moves << [x + i + 1, y + i + 1]
      potential_moves << [x + i + 1, y - i - 1]
      potential_moves << [x - i - 1, y + i + 1]
      potential_moves << [x - i - 1, y - i - 1]
    end
    potential_moves.select { |move| valid_position?(move) }
  end
end
