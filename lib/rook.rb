# frozen_string_literal: true

require_relative 'piece'
require_relative 'rook_movement'

# Straight-line sliding movement.
class Rook < Piece
  include RookMovement

  def valid_moves
    rook_moves
  end

  def piece_type
    :rook
  end
end
