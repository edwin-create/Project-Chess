# frozen_string_literal: true

require_relative 'piece'
# Pawn-specific movement and capture logic.
class Pawn < Piece
  def valid_moves # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
    row, col = position
    potential_moves = []

    # Forward movement
    potential_moves << [row - 1, col] if color == :white
    potential_moves << [row + 1, col] if color == :black

    # initial double move

    potential_moves << [row - 2, col] if color == :white && row == 6
    potential_moves << [row + 2, col] if color == :black && row == 1

    # select only valid positions
    potential_moves.select { |move| valid_position?(move) }
  end

  def capture_moves # rubocop:disable Metrics/AbcSize
    row, col = position
    potential_moves = []

    # Diagonal captures
    potential_moves << [row - 1, col + 1] if color == :white
    potential_moves << [row - 1, col - 1] if color == :white
    potential_moves << [row + 1, col + 1] if color == :black
    potential_moves << [row + 1, col - 1] if color == :black

    # select only valid positions
    potential_moves.select { |move| valid_position?(move) }
  end

  def piece_type
    :pawn
  end
end
