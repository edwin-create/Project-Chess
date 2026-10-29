# frozen_string_literal: true

require_relative 'piece'
require_relative 'rook_movement'
require_relative 'bishop_movement'

# A chess queen that combines rook and bishop movement.
class Queen < Piece
  include RookMovement
  include BishopMovement

  def valid_moves
    rook_moves + bishop_moves
  end

  def piece_type
    :queen
  end
end
