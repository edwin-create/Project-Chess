# frozen_string_literal: true

require_relative 'piece'
require_relative 'bishop_movement'
# Diagonal sliding movement.
class Bishop < Piece
  include BishopMovement

  def valid_moves
    bishop_moves
  end

  def piece_type
    :bishop
  end
end
