# frozen_string_literal: true

# A shared base class for all chess pieces.
class Piece
  attr_reader :color, :position

  SYMBOLS = {
    white: {
      king: '♔',
      queen: '♕',
      rook: '♖',
      bishop: '♗',
      knight: '♘',
      pawn: '♙'
    },
    black: {
      king: '♚',
      queen: '♛',
      rook: '♜',
      bishop: '♝',
      knight: '♞',
      pawn: '♟'
    }
  }.freeze

  def initialize(color, position)
    @color = color

    raise(ArgumentError, 'Invalid position') unless valid_position?(position)

    @position = position.dup.freeze
  end

  def update_position(new_position)
    raise(ArgumentError, 'Invalid position') unless valid_position?(new_position)

    @position = new_position.dup.freeze
  end

  def symbol
    SYMBOLS[color][piece_type]
  end

  private

  def valid_position?(position)
    return false unless position.is_a?(Array)
    return false if position.length != 2

    position.all? { |coord| coord.is_a?(Integer) && coord.between?(0, 7) }
  end
end
