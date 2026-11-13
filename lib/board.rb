# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
# Handles the grid, piece placement, and move application.
class Board # rubocop:disable Metrics/ClassLength
  attr_reader :grid

  def initialize(setup: true) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @grid = Array.new(8) { Array.new(8) }
    @last_move = nil
    return unless setup

    grid[0][0] = Rook.new(:black, [0, 0])
    grid[0][1] = Knight.new(:black, [0, 1])
    grid[0][2] = Bishop.new(:black, [0, 2])
    grid[0][3] = Queen.new(:black, [0, 3])
    grid[0][4] = King.new(:black, [0, 4])
    grid[0][5] = Bishop.new(:black, [0, 5])
    grid[0][6] = Knight.new(:black, [0, 6])
    grid[0][7] = Rook.new(:black, [0, 7])
    (0..7).each do |col|
      grid[1][col] = Pawn.new(:black, [1, col])
      grid[6][col] = Pawn.new(:white, [6, col])
    end
    grid[7][0] = Rook.new(:white, [7, 0])
    grid[7][1] = Knight.new(:white, [7, 1])
    grid[7][2] = Bishop.new(:white, [7, 2])
    grid[7][3] = Queen.new(:white, [7, 3])
    grid[7][4] = King.new(:white, [7, 4])
    grid[7][5] = Bishop.new(:white, [7, 5])
    grid[7][6] = Knight.new(:white, [7, 6])
    grid[7][7] = Rook.new(:white, [7, 7])
  end

  def place_piece(piece, position)
    raise ArgumentError, 'Invalid position' unless valid_position?(position)
    raise ArgumentError, 'Position already occupied' unless piece_at(position).nil?

    row, col = position
    grid[row][col] = piece
    piece.update_position(position)
  end

  def piece_at(position)
    raise ArgumentError, 'Invalid position' unless valid_position?(position)

    row, col = position
    grid[row][col]
  end

  def move_piece(from, to) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    raise ArgumentError, 'Invalid position' unless valid_position?(from) && valid_position?(to)

    piece = piece_at(from)
    raise ArgumentError, 'No piece at starting position' if piece.nil?

    destination_piece = piece_at(to)
    if destination_piece && destination_piece.color == piece.color
      raise ArgumentError, 'Cannot move to a position occupied by a friendly piece'
    end

    raise ArgumentError, 'Invalid move for the piece' unless valid_move?(piece, to)

    if en_passant_allowed?(piece, to)
      execute_en_passant(piece, from, to)
    else
      grid[to[0]][to[1]] = piece
      grid[from[0]][from[1]] = nil
      @last_move = { piece: piece, from: from, to: to }
      piece.update_position(to)
    end

    piece.mark_as_moved
  end

  def valid_move?(piece, to)
    valid = if piece.is_a?(Pawn)
              valid_pawn_move?(piece, to)
            elsif piece.is_a?(King)
              valid_king_move?(piece, to)
            else
              regular_move?(piece, to)
            end
    return false unless valid

    return false if leaves_the_king_in_check?(piece, to)

    true
  end

  def square_attacked?(position, color) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity,Metrics/AbcSize,Metrics/MethodLength
    raise ArgumentError, 'Invalid position' unless valid_position?(position)

    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        next if piece.nil? || piece.color == color

        if piece.is_a?(Pawn)
          return true if piece.pawn_capture_moves.include?(position)
        elsif piece.is_a?(King) || piece.is_a?(Knight)
          return true if piece.valid_moves.include?(position)
        elsif piece.valid_moves.include?(position) && path_clear?(piece.position, position)
          return true
        end
      end
    end
    false
  end

  def in_check?(color) # rubocop:disable Metrics/MethodLength
    king_position = nil
    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        if piece.is_a?(King) && piece.color == color
          king_position = [row, col]
          break
        end
      end
      break if king_position
    end

    raise ArgumentError, 'No king of the specified color on the board' unless king_position

    square_attacked?(king_position, color)
  end

  def leaves_the_king_in_check?(piece, to) # rubocop:disable Metrics/AbcSize
    original_position = piece.position
    destination_piece = piece_at(to)

    #  Ask BEFORE anything is moved. This is an en passant capture only if the
    # rules allow it, and then the pawn being captured is NOT standing on `to`.
    en_passant = en_passant_allowed?(piece, to)
    # Keep a reference to that pawn so we can put it back afterwards.
    victim = (piece_at(@last_move[:to]) if en_passant)

    # Simulate the move
    grid[to[0]][to[1]] = piece
    grid[original_position[0]][original_position[1]] = nil
    piece.update_position(to)
    # In the pretend position the captured pawn is gone too.
    remove_en_passant_victim if en_passant

    in_check = in_check?(piece.color)

    # Revert the move
    grid[original_position[0]][original_position[1]] = piece
    grid[to[0]][to[1]] = destination_piece
    piece.update_position(original_position)
    # Undo the pretend capture by putting the victim back where it stood.
    if en_passant
      victim_row, victim_col = @last_move[:to]
      grid[victim_row][victim_col] = victim
    end

    in_check
  end

  def checkmate?(color) # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    return false unless in_check?(color)

    king_position = nil

    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        if piece.is_a?(King) && piece.color == color
          king_position = [row, col]
          break
        end
      end
      break if king_position
    end
    king = piece_at(king_position)
    # 1. Check if the king has any valid, safe escape moves
    king.valid_moves.each do |move|
      return false if valid_move?(king, move)
    end
    return false if can_save_checkmate_by_blocking_or_capture?(color)

    true
  end

  def stalemate?(color)
    return false if in_check?(color) || any_piece_has_valid_moves?(color)

    true
  end

  def insufficient_material? # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    pieces = grid.flatten.compact.reject { |piece| piece.is_a?(King) }

    return true if pieces.empty?                                   # king vs king
    return false if pieces.any? { |piece| piece.is_a?(Queen) || piece.is_a?(Rook) || piece.is_a?(Pawn) }
    return true if pieces.size == 1                                # one knight or bishop

    pieces.all? { |piece| piece.is_a?(Bishop) } &&
      (pieces.map { |piece| piece.position.sum.even? }.uniq.size == 1)
  end

  def execute_castling(color, side) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    raise ArgumentError, 'Castling not allowed' unless castling_allowed?(color, side)

    if color == :white && side == :kingside

      slide_piece([7, 4], [7, 6])
      slide_piece([7, 7], [7, 5])
    elsif color == :white && side == :queenside
      slide_piece([7, 4], [7, 2])
      slide_piece([7, 0], [7, 3])
    elsif color == :black && side == :queenside
      slide_piece([0, 4], [0, 2])
      slide_piece([0, 0], [0, 3])
    elsif color == :black && side == :kingside
      slide_piece([0, 4], [0, 6])
      slide_piece([0, 7], [0, 5])
    end
  end

  def execute_en_passant(piece, from, to)
    # The victim stands where its double step ended
    remove_en_passant_victim # take the victim off the board

    grid[to[0]][to[1]] = piece # move the capturing pawn
    grid[from[0]][from[1]] = nil
    @last_move = { piece: piece, from: from, to: to }
    piece.update_position(to)
  end

  def execute_promotion(piece, promotion_type = :queen) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    raise ArgumentError, 'Invalid promotion' unless promotion_allowed?(piece)

    # Choose the new piece using if/else
    case promotion_type
    when :queen
      new_piece = Queen.new(piece.color, piece.position)
    when :rook
      new_piece = Rook.new(piece.color, piece.position)
    when :bishop
      new_piece = Bishop.new(piece.color, piece.position)
    when :knight
      new_piece = Knight.new(piece.color, piece.position)
    else
      raise ArgumentError, 'Invalid promotion piece'
    end

    # Clear the square / remove the pawn
    row, col = piece.position
    grid[row][col] = nil

    # Place the new piece on the board
    place_piece(new_piece, piece.position)
  end

  private

  def promotion_allowed?(piece)
    return false unless piece.is_a?(Pawn)

    row, _col = piece.position # using _col signals to RuboCop that we don't need the column value

    if piece.color == :black

      return false unless row == 7
    else
      return false unless row.zero?
    end
    true
  end

  def remove_en_passant_victim
    victim_row, victim_col = @last_move[:to]
    grid[victim_row][victim_col] = nil
  end

  def en_passant_allowed?(piece, to)
    return false unless piece.is_a?(Pawn)
    return false unless last_move_was_double_step?
    return false unless last_moved_pawn_is_an_enemy_beside?(piece)

    # The attacker must be moving to the exact square the victim skipped over
    to == skipped_square
  end

  def last_moved_pawn_is_an_enemy_beside?(piece)
    victim_piece = @last_move[:piece]
    return false unless victim_piece

    victim_row, victim_col = @last_move[:to]
    attacker_row, attacker_col = piece.position # piece.position returns [row, col]

    # The victim must be an enemy, not a friendly piece.
    return false if victim_piece.color == piece.color

    # The victim must be on the same row as the attacker
    return false unless victim_row == attacker_row

    # The victim must be directly beside the attacking pawn (one column away)
    return false unless (victim_col - attacker_col).abs == 1

    true
  end

  def skipped_square
    victim_start_row = @last_move[:from][0]
    victim_row = @last_move[:to][0]
    victim_col = @last_move[:to][1]

    # The square the victim skipped over is halfway between start and landing
    skipped_row = (victim_start_row + victim_row) / 2
    [skipped_row, victim_col]
  end

  def last_move_was_double_step?
    return false unless @last_move

    piece = @last_move[:piece]
    from_row = @last_move[:from][0]
    to_row = @last_move[:to][0]

    piece.is_a?(Pawn) && (to_row - from_row).abs == 2
  end

  def castling_allowed?(color, side) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    king = if color == :white
             piece_at([7, 4])
           else
             piece_at([0, 4])
           end

    return false unless king.is_a?(King) && king.color == color
    return false if king.moved? || in_check?(color)

    return castling_allowed_queenside_white_king?(color) if color == :white && side == :queenside
    return castling_allowed_kingside_white_king?(color) if color == :white && side == :kingside
    return castling_allowed_queenside_black_king?(color) if color == :black && side == :queenside
    return castling_allowed_kingside_black_king?(color) if color == :black && side == :kingside

    false
  end

  def slide_piece(from, to)
    piece = piece_at(from)
    grid[to[0]][to[1]] = piece
    grid[from[0]][from[1]] = nil
    piece.update_position(to)
    piece.mark_as_moved
  end

  def unmoved_rook?(position, color)
    rook = piece_at(position)
    rook.is_a?(Rook) && rook.color == color && !rook.moved?
  end

  def castling_allowed_queenside_black_king?(color)
    return false unless unmoved_rook?([0, 0], color)
    return false unless path_clear?([0, 4], [0, 0])
    return false if square_attacked?([0, 3], color) || square_attacked?([0, 2], color)

    true
  end

  def castling_allowed_kingside_black_king?(color)
    return false unless unmoved_rook?([0, 7], color)
    return false unless path_clear?([0, 4], [0, 7])
    return false if square_attacked?([0, 5], color) || square_attacked?([0, 6], color)

    true
  end

  def castling_allowed_queenside_white_king?(color)
    return false unless unmoved_rook?([7, 0], color)
    return false unless path_clear?([7, 4], [7, 0])
    return false if square_attacked?([7, 3], color) || square_attacked?([7, 2], color)

    true
  end

  def castling_allowed_kingside_white_king?(color)
    return false unless unmoved_rook?([7, 7], color)
    return false unless path_clear?([7, 4], [7, 7])
    return false if square_attacked?([7, 5], color) || square_attacked?([7, 6], color)

    true
  end

  def any_piece_has_valid_moves?(color) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        next if piece.nil? || piece.color != color

        if piece.is_a?(Pawn)
          (piece.pawn_capture_moves + piece.valid_moves).each do |move|
            return true if valid_move?(piece, move)
          end
        else
          piece.valid_moves.each do |move|
            return true if valid_move?(piece, move)
          end
        end
      end
    end

    false
  end

  def can_save_checkmate_by_blocking_or_capture?(color) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity
    # Implementation for checking if a checkmate can be saved by blocking
    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        next if piece.nil? || piece.color != color || piece.is_a?(King)

        if piece.is_a?(Pawn)
          (piece.pawn_capture_moves + piece.valid_moves).each do |move|
            return true if valid_move?(piece, move)
          end

        else
          piece.valid_moves.each do |move|
            return true if valid_move?(piece, move)
          end
        end
      end
    end

    false
  end

  def valid_king_move?(piece, to)
    return false unless piece.is_a?(King) && valid_position?(to)

    destination_piece = piece_at(to)
    if destination_piece.nil?
      king_can_move?(piece, to)
    else
      king_can_capture?(piece, to, destination_piece)
    end
  end

  def king_can_move?(piece, to)
    piece.valid_moves.include?(to)
  end

  def king_can_capture?(piece, to, destination_piece)
    piece.valid_moves.include?(to) && destination_piece.color != piece.color
  end

  def valid_pawn_move?(piece, to)
    return false unless piece.is_a?(Pawn) && valid_position?(to)

    destination_piece = piece_at(to)

    if destination_piece.nil?
      pawn_can_advance?(piece, to) || en_passant_allowed?(piece, to)
    else
      pawn_can_capture?(piece, to, destination_piece)
    end
  end

  def pawn_can_advance?(pawn, to)
    pawn.valid_moves.include?(to) && path_clear?(pawn.position, to)
  end

  def pawn_can_capture?(pawn, to, destination_piece)
    pawn.pawn_capture_moves.include?(to) && pawn.color != destination_piece.color
  end

  def regular_move?(piece, to) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity,Metrics/MethodLength
    return false unless valid_position?(to)
    return false if piece.nil?

    destination_piece = piece_at(to)

    return false unless piece.valid_moves.include?(to)
    return false if destination_piece && destination_piece.color == piece.color

    if (piece.is_a?(Bishop) || piece.is_a?(Rook) || piece.is_a?(Queen)) && !path_clear?(
      piece.position, to
    )
      return false
    end

    true
  end

  def path_clear?(from, to) # rubocop:disable Metrics/MethodLength
    row1, col1 = from
    row2, col2 = to

    row_step = row2 <=> row1
    col_step = col2 <=> col1

    current_row = row1 + row_step
    current_col = col1 + col_step

    while current_row != row2 || current_col != col2
      return false unless piece_at([current_row, current_col]).nil?

      current_row += row_step
      current_col += col_step
    end

    true
  end

  def valid_position?(position)
    return false unless position.is_a?(Array)
    return false if position.length != 2

    position.all? { |coord| coord.is_a?(Integer) && coord.between?(0, 7) }
  end
end
