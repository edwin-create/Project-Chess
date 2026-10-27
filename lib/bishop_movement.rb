# frozen_string_literal: true

# Diagonal sliding movement.
module BishopMovement
  def bishop_moves # rubocop:disable Metrics/AbcSize
    row, col = position
    potential_moves = []
    # Generate all potential moves in the diagonal direction
    7.times do |i|
      potential_moves << [row + i + 1, col + i + 1]
      potential_moves << [row + i + 1, col - i - 1]
      potential_moves << [row - i - 1, col + i + 1]
      potential_moves << [row - i - 1, col - i - 1]
    end
    potential_moves.select { |move| valid_position?(move) }
  end
end
