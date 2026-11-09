# frozen_string_literal: true

require_relative '../lib/board'

describe Board do # rubocop:disable Metrics/BlockLength
  describe '#initialize' do # rubocop:disable Metrics/BlockLength
    it 'initializes an 8x8 board' do
      board = Board.new
      expect(board.grid.size).to eq(8)
      expect(board.grid.all? { |row| row.size == 8 }).to be true
    end
    it 'checks that pawns are placed correctly' do
      board = Board.new
      # Check pawns
      (0..7).each do |col|
        expect(board.grid[1][col].piece_type).to eq(:pawn)
        expect(board.grid[1][col].color).to eq(:black)
        expect(board.grid[6][col].piece_type).to eq(:pawn)
        expect(board.grid[6][col].color).to eq(:white)
      end
    end
    it 'checks that rooks are placed correctly' do
      board = Board.new
      # Check rooks
      expect(board.grid[0][0].piece_type).to eq(:rook)
      expect(board.grid[0][0].color).to eq(:black)
      expect(board.grid[0][7].piece_type).to eq(:rook)
      expect(board.grid[0][7].color).to eq(:black)
      expect(board.grid[7][0].piece_type).to eq(:rook)
      expect(board.grid[7][0].color).to eq(:white)
      expect(board.grid[7][7].piece_type).to eq(:rook)
      expect(board.grid[7][7].color).to eq(:white)
    end
    it 'checks that knights are placed correctly' do
      board = Board.new
      # Check knights
      expect(board.grid[0][1].piece_type).to eq(:knight)
      expect(board.grid[0][1].color).to eq(:black)
      expect(board.grid[0][6].piece_type).to eq(:knight)
      expect(board.grid[0][6].color).to eq(:black)
      expect(board.grid[7][1].piece_type).to eq(:knight)
      expect(board.grid[7][1].color).to eq(:white)
      expect(board.grid[7][6].piece_type).to eq(:knight)
      expect(board.grid[7][6].color).to eq(:white)
    end
    it 'checks that bishops are placed correctly' do
      board = Board.new
      # Check bishops
      expect(board.grid[0][2].piece_type).to eq(:bishop)
      expect(board.grid[0][2].color).to eq(:black)
      expect(board.grid[0][5].piece_type).to eq(:bishop)
      expect(board.grid[0][5].color).to eq(:black)
      expect(board.grid[7][2].piece_type).to eq(:bishop)
      expect(board.grid[7][2].color).to eq(:white)
      expect(board.grid[7][5].piece_type).to eq(:bishop)
      expect(board.grid[7][5].color).to eq(:white)
    end
    it 'checks that queens are placed correctly' do
      board = Board.new
      # Check queens
      expect(board.grid[0][3].piece_type).to eq(:queen)
      expect(board.grid[0][3].color).to eq(:black)
      expect(board.grid[7][3].piece_type).to eq(:queen)
      expect(board.grid[7][3].color).to eq(:white)
    end
    it 'checks that kings are placed correctly' do
      board = Board.new
      # Check kings
      expect(board.grid[0][4].piece_type).to eq(:king)
      expect(board.grid[0][4].color).to eq(:black)
      expect(board.grid[7][4].piece_type).to eq(:king)
      expect(board.grid[7][4].color).to eq(:white)
    end
    it 'leaves the middle four rows empty' do
      board = Board.new

      (2..5).each do |row|
        expect(board.grid[row]).to all(be_nil)
      end
    end
    it 'initializes an empty board when setup is false' do
      board = Board.new(setup: false)

      expect(board.grid.flatten).to all(be_nil)
    end

    it 'initializes the standard chess position by default' do
      board = Board.new

      expect(board.piece_at([0, 4])).to be_a(King)
      expect(board.piece_at([7, 4])).to be_a(King)
      expect(board.piece_at([1, 4])).to be_a(Pawn)
      expect(board.piece_at([6, 4])).to be_a(Pawn)
    end
  end
  describe '#piece_at' do
    it 'returns the correct piece at a given position' do
      board = Board.new
      expect(board.piece_at([0, 0]).piece_type).to eq(:rook)
      expect(board.piece_at([0, 0]).color).to eq(:black)
      expect(board.piece_at([7, 7]).piece_type).to eq(:rook)
      expect(board.piece_at([7, 7]).color).to eq(:white)
    end

    it 'returns nil for an empty position' do
      board = Board.new
      expect(board.piece_at([3, 3])).to be_nil
    end

    it 'raises an error for an invalid position' do
      board = Board.new
      expect { board.piece_at([-1, 0]) }.to raise_error(ArgumentError)
      expect { board.piece_at([0, -1]) }.to raise_error(ArgumentError)
      expect { board.piece_at([8, 0]) }.to raise_error(ArgumentError)
      expect { board.piece_at([0, 8]) }.to raise_error(ArgumentError)
    end
  end
  describe '#move_piece' do # rubocop:disable Metrics/BlockLength
    it 'moves a piece from one position to another' do
      board = Board.new
      piece = board.piece_at([0, 1]) # Black knight at [0, 1]
      board.move_piece([0, 1], [2, 2]) # Move to [2, 2]

      expect(board.piece_at([2, 2])).to equal(piece)
      expect(board.piece_at([0, 1])).to be_nil
      expect(piece.position).to eq([2, 2])
    end
    it 'raises an error when the starting position is empty' do
      board = Board.new

      expect { board.move_piece([3, 3], [2, 2]) }
        .to raise_error(ArgumentError, 'No piece at starting position')
    end
    it 'raises an error when the destination position is held by a piece of the same color' do
      board = Board.new

      expect { board.move_piece([0, 1], [0, 0]) }
        .to raise_error(ArgumentError, 'Cannot move to a position occupied by a friendly piece')
    end
    it 'raises an error when the starting position is invalid' do
      board = Board.new

      expect { board.move_piece([-1, 0], [2, 2]) }
        .to raise_error(ArgumentError, 'Invalid position')
    end
    it 'raises an error when the destination position is invalid' do
      board = Board.new

      expect { board.move_piece([0, 1], [8, 2]) }
        .to raise_error(ArgumentError, 'Invalid position')
    end
    it 'raises an error when the movement is not valid for the piece' do
      board = Board.new
      piece = board.piece_at([0, 1])

      expect { board.move_piece([0, 1], [3, 3]) }
        .to raise_error(ArgumentError, 'Invalid move for the piece')

      expect(board.piece_at([0, 1])).to equal(piece)
      expect(board.piece_at([3, 3])).to be_nil
      expect(piece.position).to eq([0, 1])
    end
    it 'raises an error when another piece blocks the movement path' do
      board = Board.new
      rook = board.piece_at([0, 0])
      blocking_piece = board.piece_at([1, 0])

      expect { board.move_piece([0, 0], [3, 0]) }
        .to raise_error(ArgumentError, 'Invalid move for the piece')

      expect(board.piece_at([0, 0])).to equal(rook)
      expect(board.piece_at([1, 0])).to equal(blocking_piece)
      expect(board.piece_at([3, 0])).to be_nil
      expect(rook.position).to eq([0, 0])
    end
  end
  describe '#valid_move?' do
    it 'returns true when the destination is a valid candidate move' do
      board = Board.new
      knight = board.piece_at([0, 1])

      expect(board.valid_move?(knight, [2, 2])).to be true
    end

    it 'returns false when the destination is not a valid candidate move' do
      board = Board.new
      knight = board.piece_at([0, 1])

      expect(board.valid_move?(knight, [3, 3])).to be false
    end
    it 'returns false when the destination is occupied by a friendly piece' do
      board = Board.new
      knight = board.piece_at([0, 1])

      expect(board.valid_move?(knight, [0, 0])).to be false
    end
    it 'returns false when rook is blocked by pawn' do
      board = Board.new
      rook = board.piece_at([0, 0])

      expect(board.valid_move?(rook, [3, 0])).to be false
    end
  end
  describe '#valid_move? for pawns' do # rubocop:disable Metrics/BlockLength
    let(:board) { Board.new }

    it 'allows a pawn to move one square forward into an empty square' do
      pawn = board.piece_at([6, 4])

      expect(board.valid_move?(pawn, [5, 4])).to be true
    end

    it 'allows a pawn to move two squares forward on its first move' do
      pawn = board.piece_at([6, 4])

      expect(board.valid_move?(pawn, [4, 4])).to be true
    end

    it 'rejects a pawn moving forward into an occupied square' do
      pawn = board.piece_at([6, 4])
      board.move_piece([1, 4], [3, 4])
      board.move_piece([3, 4], [4, 4])
      board.move_piece([4, 4], [5, 4])

      expect(board.valid_move?(pawn, [5, 4])).to be false
    end

    it 'rejects a pawn moving diagonally into an empty square' do
      pawn = board.piece_at([6, 4])

      expect(board.valid_move?(pawn, [5, 5])).to be false
    end

    it 'allows a pawn to capture an opponent diagonally' do
      pawn = board.piece_at([6, 4])
      board.move_piece([1, 5], [3, 5])
      board.move_piece([3, 5], [4, 5])
      board.move_piece([4, 5], [5, 5])

      expect(board.valid_move?(pawn, [5, 5])).to be true
    end

    it 'rejects a pawn capturing a friendly piece diagonally' do
      pawn = board.piece_at([6, 4])
      board.move_piece([6, 5], [5, 5])

      expect(board.valid_move?(pawn, [5, 5])).to be false
    end

    it 'rejects a two-square move when the intermediate square is occupied' do
      pawn = board.piece_at([6, 4])
      board.move_piece([1, 4], [3, 4])
      board.move_piece([3, 4], [4, 4])
      board.move_piece([4, 4], [5, 4])

      expect(board.valid_move?(pawn, [4, 4])).to be false
    end
  end
  describe '#valid_move? for kings' do # rubocop:disable Metrics/BlockLength
    let(:board) { Board.new }

    it 'allows a king to move one square horizontally' do
      board.move_piece([1, 4], [2, 4])
      board.move_piece([1, 5], [2, 5])
      board.move_piece([0, 4], [1, 4])

      king = board.piece_at([1, 4])

      expect(board.valid_move?(king, [1, 5])).to be true
    end
    it 'allows a king to move one square diagonally' do
      board.move_piece([1, 4], [2, 4])
      board.move_piece([0, 4], [1, 4])

      king = board.piece_at([1, 4])

      expect(board.valid_move?(king, [2, 5])).to be true
    end
    it 'allows a king to capture an undefended opponent piece' do
      board.move_piece([1, 4], [2, 4]) # clear the king's way
      board.move_piece([0, 4], [1, 4])   # black king steps up

      board.move_piece([6, 5], [5, 5])   # white pawn marches up the f-file
      board.move_piece([5, 5], [4, 5])
      board.move_piece([4, 5], [3, 5])
      board.move_piece([3, 5], [2, 5])   # lands next to the king, giving check

      king = board.piece_at([1, 4])

      expect(board.valid_move?(king, [2, 5])).to be true
    end

    it 'rejects a king moving more than one square' do
      king = board.piece_at([0, 4])

      expect(board.valid_move?(king, [2, 4])).to be false
    end

    it 'rejects a king capturing a friendly piece' do
      king = board.piece_at([0, 4])

      expect(board.valid_move?(king, [0, 3])).to be false
    end
  end
  describe '#place_piece' do # rubocop:disable Metrics/BlockLength
    it 'places a piece at a valid empty position' do
      board = Board.new(setup: false)
      pawn = Pawn.new(:white, [5, 4])

      board.place_piece(pawn, [4, 4])

      expect(board.piece_at([4, 4])).to equal(pawn)
      expect(pawn.position).to eq([4, 4])
    end
    it 'raises an error when placing a piece at an occupied position' do
      board = Board.new(setup: false)
      pawn = Pawn.new(:white, [6, 4])
      board.place_piece(pawn, [6, 4])
      expect { board.place_piece(pawn, [6, 4]) }
        .to raise_error(ArgumentError, 'Position already occupied')
    end

    it 'raises an error when placing a piece at an invalid position' do
      board = Board.new(setup: false)
      pawn = Pawn.new(:white, [6, 4])

      expect { board.place_piece(pawn, [8, 4]) }
        .to raise_error(ArgumentError, 'Invalid position')
    end

    it 'raises an error when placing a piece at an occupied position' do
      board = Board.new
      pawn = Pawn.new(:white, [6, 4])

      expect { board.place_piece(pawn, [1, 4]) }
        .to raise_error(ArgumentError, 'Position already occupied')
    end
  end
  describe '#square_attacked?' do
    it 'returns true when an opposing rook attacks a square' do
      board = Board.new(setup: false)
      rook = Rook.new(:black, [0, 0])
      board.place_piece(rook, [0, 0])

      expect(board.square_attacked?([0, 5], :white)).to be true
    end

    it 'returns false when an opposing rook is blocked' do
      board = Board.new(setup: false)
      rook = Rook.new(:black, [0, 0])
      pawn = Pawn.new(:black, [0, 3])
      board.place_piece(rook, [0, 0])
      board.place_piece(pawn, [0, 3])

      expect(board.square_attacked?([0, 5], :white)).to be false
    end

    it 'returns true when an opposing pawn attacks an empty diagonal square' do
      board = Board.new(setup: false)
      pawn = Pawn.new(:black, [3, 3])
      board.place_piece(pawn, [3, 3])

      expect(board.square_attacked?([4, 4], :white)).to be true
    end

    it 'returns false when only friendly pieces attack the square' do
      board = Board.new(setup: false)
      rook = Rook.new(:white, [0, 0])
      board.place_piece(rook, [0, 0])

      expect(board.square_attacked?([0, 5], :white)).to be false
    end

    it 'returns false when no opposing piece attacks the square' do
      board = Board.new(setup: false)
      knight = Knight.new(:black, [0, 0])
      board.place_piece(knight, [0, 0])

      expect(board.square_attacked?([3, 3], :white)).to be false
    end

    it 'raises an error for an invalid position' do
      board = Board.new(setup: false)

      expect { board.square_attacked?([8, 4], :white) }
        .to raise_error(ArgumentError, 'Invalid position')
    end
  end
  describe '#in_check?' do
    it 'returns true when the king is in check' do
      board = Board.new(setup: false)
      king = King.new(:white, [4, 4])
      rook = Rook.new(:black, [4, 0])
      board.place_piece(king, [4, 4])
      board.place_piece(rook, [4, 0])

      expect(board.in_check?(:white)).to be true
    end

    it 'returns false when the king is not in check' do
      board = Board.new(setup: false)
      king = King.new(:white, [4, 4])
      rook = Rook.new(:black, [0, 0])
      board.place_piece(king, [4, 4])
      board.place_piece(rook, [0, 0])

      expect(board.in_check?(:white)).to be false
    end

    it 'raises an error when there is no king of the specified color' do
      board = Board.new(setup: false)

      expect { board.in_check?(:white) }
        .to raise_error(ArgumentError, 'No king of the specified color on the board')
    end
  end
  describe '#leaves_the_king_in_check?' do
    it 'returns true when a move leaves the king in check' do
      board = Board.new(setup: false)
      king = King.new(:white, [4, 4])
      rook = Rook.new(:black, [4, 0])
      pawn = Pawn.new(:white, [4, 2])
      board.place_piece(king, [4, 4])
      board.place_piece(rook, [4, 0])
      board.place_piece(pawn, [4, 2])

      expect(board.leaves_the_king_in_check?(pawn, [3, 2])).to be true
    end

    it 'returns false when a move does not leave the king in check' do
      board = Board.new(setup: false)
      king = King.new(:white, [4, 4])
      rook = Rook.new(:black, [0, 0])
      knight = Knight.new(:white, [6, 2])
      board.place_piece(king, [4, 4])
      board.place_piece(rook, [0, 0])
      board.place_piece(knight, [6, 2])

      expect(board.leaves_the_king_in_check?(knight, [4, 3])).to be false
    end

    it 'restores the board after checking' do
      board = Board.new(setup: false)
      king = King.new(:white, [4, 4])
      rook = Rook.new(:black, [4, 0])
      pawn = Pawn.new(:white, [4, 2])

      board.place_piece(king, [4, 4])
      board.place_piece(rook, [4, 0])
      board.place_piece(pawn, [4, 2])

      board.leaves_the_king_in_check?(pawn, [3, 2])

      expect(pawn.position).to eq([4, 2])
      expect(board.piece_at([4, 2])).to equal(pawn)
      expect(board.piece_at([3, 2])).to be_nil
    end
  end
  describe '#checkmate?' do
    it 'returns true when the king is in checkmate' do
      board = Board.new(setup: false)
      king = King.new(:white, [0, 0])
      rook1 = Rook.new(:black, [0, 7])
      rook2 = Rook.new(:black, [1, 7])
      board.place_piece(king, [0, 0])
      board.place_piece(rook1, [0, 7])
      board.place_piece(rook2, [1, 7])

      expect(board.checkmate?(:white)).to be true
    end

    it 'returns false when the king is not in checkmate' do
      board = Board.new(setup: false)
      king = King.new(:white, [4, 4])
      rook = Rook.new(:black, [4, 0])
      knight = Knight.new(:white, [6, 2])
      board.place_piece(king, [4, 4])
      board.place_piece(rook, [4, 0])
      board.place_piece(knight, [6, 2])

      expect(board.checkmate?(:white)).to be false
    end
    it 'returns false when the king is not in check' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [4, 4]), [4, 4])
      board.place_piece(Rook.new(:black, [0, 0]), [0, 0])

      expect(board.checkmate?(:white)).to be false
    end
    it 'returns false when another piece can capture the checking piece' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Bishop.new(:white, [4, 3]), [4, 3])
      board.place_piece(Rook.new(:black, [0, 7]), [0, 7])
      board.place_piece(Rook.new(:black, [1, 7]), [1, 7])

      expect(board.checkmate?(:white)).to be false
    end
    it 'returns false when another piece can block the check' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Rook.new(:white, [3, 3]), [3, 3])
      board.place_piece(Rook.new(:black, [0, 7]), [0, 7])
      board.place_piece(Rook.new(:black, [1, 7]), [1, 7])

      expect(board.checkmate?(:white)).to be false
    end
    it 'does not let the king escape along the line of the attack' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 1]), [0, 1])
      board.place_piece(Rook.new(:black, [0, 7]), [0, 7])
      board.place_piece(Rook.new(:black, [1, 7]), [1, 7])

      expect(board.checkmate?(:white)).to be true
    end
    it 'returns true when the only blocking piece is pinned' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Queen.new(:white, [2, 2]), [2, 2])
      board.place_piece(Bishop.new(:black, [4, 4]), [4, 4])
      board.place_piece(Rook.new(:black, [0, 7]), [0, 7])
      board.place_piece(Rook.new(:black, [1, 7]), [1, 7])

      expect(board.checkmate?(:white)).to be true
    end
    it 'returns false for stalemate (no legal moves but not in check)' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Queen.new(:black, [2, 1]), [2, 1])

      expect(board.checkmate?(:white)).to be false
    end
    it 'returns false when a pawn captures the attacking piece diagonally' do
      board = Board.new(setup: false)

      # King is in check by a bishop or knight or rook positioned diagonally
      board.place_piece(King.new(:white, [2, 2]), [2, 2])

      # Attacking piece is positioned at [1, 1] delivering a check
      board.place_piece(Bishop.new(:black, [1, 1]), [1, 1])

      # White pawn is right there at [2, 0], and its diagonal capture target is [1, 1]!
      board.place_piece(Pawn.new(:white, [2, 0]), [2, 0])

      expect(board.checkmate?(:white)).to be false
    end
    it 'returns false for a doublecheck' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [4, 4]), [4, 4])
      board.place_piece(Rook.new(:black, [4, 0]), [4, 0])
      board.place_piece(Bishop.new(:black, [2, 2]), [2, 2])
      board.place_piece(Rook.new(:white, [5, 4]), [5, 4])
      expect(board.checkmate?(:white)).to be false
    end
  end
  describe '#stalemate?' do
    it 'returns true when the king is not in check but has no legal moves' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Queen.new(:black, [2, 1]), [2, 1])
      board.place_piece(Rook.new(:black, [1, 2]), [1, 2])

      expect(board.stalemate?(:white)).to be true
    end

    it 'returns false when the king is in check' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Queen.new(:black, [1, 1]), [1, 1])

      expect(board.stalemate?(:white)).to be false
    end

    it 'returns false when the king has legal moves' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [4, 4]), [4, 4])
      board.place_piece(Rook.new(:black, [0, 0]), [0, 0])

      expect(board.stalemate?(:white)).to be false
    end
    it 'returns false for two bare kings, because white can still move' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])

      expect(board.stalemate?(:white)).to be false
    end
    it 'returns false when the white king has no legal moves but another white piece can move' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])     # a1
      board.place_piece(Pawn.new(:white, [0, 1]), [0, 1])     # a2
      board.place_piece(Pawn.new(:white, [1, 1]), [1, 1])     # b2
      board.place_piece(Bishop.new(:black, [3, 2]), [3, 2])   # d3 (attacks b1)
      board.place_piece(Knight.new(:black, [3, 1]), [3, 1])   # d2 (Black Knight)
      board.place_piece(Rook.new(:white, [7, 0]), [7, 0])     # h1 (White Rook that can move)
      expect(board.stalemate?(:white)).to be false
    end
  end
  describe '#insufficient_material?' do # rubocop:disable Metrics/BlockLength
    it 'returns true for king vs king' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])

      expect(board.insufficient_material?).to be true
    end
    it 'returns false when a queen is still on the board' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      board.place_piece(Queen.new(:black, [3, 3]), [3, 3])
      expect(board.insufficient_material?).to be false
    end
    it 'returns true when a single minor material remains versus a lone king' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      board.place_piece(Knight.new(:black, [3, 3]), [3, 3])
      expect(board.insufficient_material?).to be true
    end

    it 'returns false for a knight and a bishop together against a lone king' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      board.place_piece(Knight.new(:white, [1, 5]), [1, 5])
      board.place_piece(Bishop.new(:white, [3, 2]), [3, 2])
      expect(board.insufficient_material?).to be false
    end
    it 'returns false for two knights vs a lone king' do # Official chess rule
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      board.place_piece(Knight.new(:black, [5, 3]), [5, 3])
      board.place_piece(Knight.new(:black, [3, 3]), [3, 3])
      expect(board.insufficient_material?).to be false
    end

    it 'returns false for two knights vs a lone king' do # Official chess rules
      board = Board.new(setup: false)
      board.place_piece(King.new(:black, [0, 0]), [0, 0])
      board.place_piece(King.new(:white, [7, 7]), [7, 7])
      board.place_piece(Knight.new(:white, [5, 3]), [5, 3])
      board.place_piece(Knight.new(:white, [3, 3]), [3, 3])
      expect(board.insufficient_material?).to be false
    end
    it 'returns false for two knights vs a king and a bishop' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Knight.new(:white, [3, 3]), [3, 3])
      board.place_piece(Knight.new(:white, [5, 5]), [5, 5])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      board.place_piece(Bishop.new(:black, [1, 5]), [1, 5])
      expect(board.insufficient_material?).to be false
    end

    it 'returns true for two same-colored bishops vs a lone king' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Bishop.new(:white, [5, 7]), [5, 7])
      board.place_piece(Bishop.new(:black, [3, 5]), [3, 5])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      expect(board.insufficient_material?).to be true
    end

    it 'returns false for two opposite-colored bishops vs a lone king' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Bishop.new(:white, [1, 1]), [1, 1])
      board.place_piece(Bishop.new(:white, [3, 4]), [3, 4])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      expect(board.insufficient_material?).to be false
    end

    it 'returns false for a knight vs a knight' do
      board = Board.new(setup: false)
      board.place_piece(King.new(:white, [0, 0]), [0, 0])
      board.place_piece(Knight.new(:white, [2, 3]), [2, 3])
      board.place_piece(King.new(:black, [7, 7]), [7, 7])
      board.place_piece(Knight.new(:black, [5, 4]), [5, 4])
      expect(board.insufficient_material?).to be false
    end
  end
  describe '#insufficient_material?' do
    # Official rule: a draw only when no sequence of moves could ever reach mate.
    # Dead positions: K vs K, K + one knight/bishop vs K, and bishops that all
    # sit on the same square color. Everything else keeps the game going.
    let(:white_king) { King.new(:white, [0, 0]) }
    let(:black_king) { King.new(:black, [7, 7]) }

    def board_with(*pieces)
      board = Board.new(setup: false)
      pieces.each { |piece| board.place_piece(piece, piece.position) }
      board
    end

    context 'when the position is dead (insufficient material)' do
      it 'is true for king vs king' do
        board = board_with(white_king, black_king)

        expect(board.insufficient_material?).to be true
      end

      it 'is true for a lone king vs king and knight (black knight)' do
        board = board_with(white_king, black_king, Knight.new(:black, [3, 3]))

        expect(board.insufficient_material?).to be true
      end

      it 'is true for a lone king vs king and knight (white knight)' do
        board = board_with(white_king, black_king, Knight.new(:white, [3, 3]))

        expect(board.insufficient_material?).to be true
      end

      it 'is true for a lone king vs king and bishop (black bishop)' do
        board = board_with(white_king, black_king, Bishop.new(:black, [1, 5]))

        expect(board.insufficient_material?).to be true
      end

      it 'is true for a lone king vs king and bishop (white bishop)' do
        board = board_with(white_king, black_king, Bishop.new(:white, [1, 5]))

        expect(board.insufficient_material?).to be true
      end

      it 'is true for a bishop each when both bishops are on the same square color' do
        board = board_with(white_king, black_king,
                           Bishop.new(:black, [1, 5]), Bishop.new(:white, [7, 3]))

        expect(board.insufficient_material?).to be true
      end

      it 'is true for two same-colored bishops on one side vs a lone king' do
        board = board_with(white_king, black_king,
                           Bishop.new(:white, [2, 2]), Bishop.new(:white, [4, 6]))

        expect(board.insufficient_material?).to be true
      end
    end

    context 'when mate is still possible (play continues)' do
      it 'is false when a queen is on the board' do
        board = board_with(white_king, black_king, Queen.new(:black, [3, 3]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false when a rook is on the board' do
        board = board_with(white_king, black_king, Rook.new(:black, [3, 3]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false when a pawn is on the board' do
        board = board_with(white_king, black_king, Pawn.new(:white, [3, 3]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for two black knights vs a lone white king' do
        board = board_with(white_king, black_king,
                           Knight.new(:black, [5, 3]), Knight.new(:black, [3, 3]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for two white knights vs a lone black king' do
        board = board_with(white_king, black_king,
                           Knight.new(:white, [5, 3]), Knight.new(:white, [3, 3]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for a knight and a bishop vs a lone king' do
        board = board_with(white_king, black_king,
                           Knight.new(:white, [1, 5]), Bishop.new(:white, [3, 2]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for a bishop each when the bishops are on opposite square colors' do
        board = board_with(white_king, black_king,
                           Bishop.new(:black, [1, 5]), Bishop.new(:white, [3, 2]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for two opposite-colored bishops vs a lone king' do
        board = board_with(white_king, black_king,
                           Bishop.new(:white, [1, 1]), Bishop.new(:white, [3, 4]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for a knight each' do
        board = board_with(white_king, black_king,
                           Knight.new(:white, [2, 3]), Knight.new(:black, [5, 4]))

        expect(board.insufficient_material?).to be false
      end

      it 'is false for a bishop vs a knight' do
        board = board_with(white_king, black_king,
                           Bishop.new(:white, [1, 5]), Knight.new(:black, [5, 4]))

        expect(board.insufficient_material?).to be false
      end
    end
  end
  describe '#castling_allowed?' do
    let(:board) { Board.new(setup: false) }
    let(:king) { King.new(:white, [7, 4]) }
    let(:kingside_rook) { Rook.new(:white, [7, 7]) }
    let(:queenside_rook) { Rook.new(:white, [7, 0]) }
    let(:enemy_king) { King.new(:black, [0, 0]) }

    before do
      [king, kingside_rook, queenside_rook, enemy_king].each do |piece|
        board.place_piece(piece, piece.position)
      end
    end

    %i[kingside queenside].each do |side|
      it "is allowed on the #{side} when nothing stands in the way" do
        expect(board.castling_allowed?(:white, side)).to be true
      end

      it "is not allowed on the #{side} once the king has moved" do
        king.mark_as_moved

        expect(board.castling_allowed?(:white, side)).to be false
      end

      it "is not allowed on the #{side} while the king is in check" do
        board.place_piece(Rook.new(:black, [0, 4]), [0, 4])

        expect(board.castling_allowed?(:white, side)).to be false
      end
    end

    it 'is not allowed on a side whose rook has moved, but the other side still is' do
      kingside_rook.mark_as_moved

      expect(board.castling_allowed?(:white, :kingside)).to be false
      expect(board.castling_allowed?(:white, :queenside)).to be true
    end

    { kingside: [7, 6], queenside: [7, 1] }.each do |side, square|
      it "is not allowed when a piece stands between the king and the #{side} rook" do
        board.place_piece(Knight.new(:white, square), square)

        expect(board.castling_allowed?(:white, side)).to be false
      end
    end

    it 'is not allowed when the rook is missing from its corner' do
      lonely = Board.new(setup: false)
      lonely.place_piece(King.new(:white, [7, 4]), [7, 4])
      lonely.place_piece(King.new(:black, [0, 0]), [0, 0])

      expect(lonely.castling_allowed?(:white, :kingside)).to be false
    end

    {
      'passes through' => { kingside: [0, 5], queenside: [0, 3] },
      'lands on' => { kingside: [0, 6], queenside: [0, 2] }
    }.each do |description, attackers|
      attackers.each do |side, square|
        it "is not allowed on the #{side} when the king #{description} an attacked square" do
          board.place_piece(Rook.new(:black, square), square)

          expect(board.castling_allowed?(:white, side)).to be false
        end
      end
    end

    it 'is still allowed on the queenside when only the b-file square is attacked' do
      board.place_piece(Rook.new(:black, [0, 1]), [0, 1])

      expect(board.castling_allowed?(:white, :queenside)).to be true
    end

    it 'works the same way for black' do
      black_board = Board.new(setup: false)
      black_board.place_piece(King.new(:black, [0, 4]), [0, 4])
      black_board.place_piece(Rook.new(:black, [0, 7]), [0, 7])
      black_board.place_piece(King.new(:white, [7, 0]), [7, 0])

      expect(black_board.castling_allowed?(:black, :kingside)).to be true
    end
  end
  describe '#execute_castling' do
    context 'when white kingside castling is executed' do
      it 'moves the white king from [7, 4] to [7, 6] and the rook from [7, 7] to [7, 5]' do
        board = Board.new(setup: false)
        king = King.new(:white, [7, 4])
        rook = Rook.new(:white, [7, 7])

        board.place_piece(king, [7, 4])
        board.place_piece(rook, [7, 7])

        board.execute_castling(:white, :kingside)

        expect(board.piece_at([7, 4])).to be_nil
        expect(board.piece_at([7, 7])).to be_nil
        expect(board.piece_at([7, 6])).to eq(king)
        expect(board.piece_at([7, 5])).to eq(rook)
        expect(king.moved?).to be true
        expect(rook.moved?).to be true
      end
    end

    context 'when white queenside castling is executed' do
      it 'moves the white king from [7, 4] to [7, 2] and the rook from [7, 0] to [7, 3]' do
        board = Board.new(setup: false)
        king = King.new(:white, [7, 4])
        rook = Rook.new(:white, [7, 0])

        board.place_piece(king, [7, 4])
        board.place_piece(rook, [7, 0])

        board.execute_castling(:white, :queenside)

        expect(board.piece_at([7, 4])).to be_nil
        expect(board.piece_at([7, 0])).to be_nil
        expect(board.piece_at([7, 2])).to eq(king)
        expect(board.piece_at([7, 3])).to eq(rook)
        expect(king.moved?).to be true
        expect(rook.moved?).to be true
      end
    end

    context 'when black kingside castling is executed' do
      it 'moves the black king from [0, 4] to [0, 6] and the rook from [0, 7] to [0, 5]' do
        board = Board.new(setup: false)
        king = King.new(:black, [0, 4])
        rook = Rook.new(:black, [0, 7])

        board.place_piece(king, [0, 4])
        board.place_piece(rook, [0, 7])

        board.execute_castling(:black, :kingside)

        expect(board.piece_at([0, 4])).to be_nil
        expect(board.piece_at([0, 7])).to be_nil
        expect(board.piece_at([0, 6])).to eq(king)
        expect(board.piece_at([0, 5])).to eq(rook)
        expect(king.moved?).to be true
        expect(rook.moved?).to be true
      end
    end

    context 'when black queenside castling is executed' do
      it 'moves the black king from [0, 4] to [0, 2] and the rook from [0, 0] to [0, 3]' do
        board = Board.new(setup: false)
        king = King.new(:black, [0, 4])
        rook = Rook.new(:black, [0, 0])

        board.place_piece(king, [0, 4])
        board.place_piece(rook, [0, 0])

        board.execute_castling(:black, :queenside)

        expect(board.piece_at([0, 4])).to be_nil
        expect(board.piece_at([0, 0])).to be_nil
        expect(board.piece_at([0, 2])).to eq(king)
        expect(board.piece_at([0, 3])).to eq(rook)
        expect(king.moved?).to be true
        expect(rook.moved?).to be true
      end
    end

    context 'when castling is not allowed' do
      it 'does not move any pieces if the path is blocked' do
        board = Board.new(setup: false)
        king = King.new(:white, [7, 4])
        rook = Rook.new(:white, [7, 7])
        blocking_pawn = Pawn.new(:white, [7, 5])

        board.place_piece(king, [7, 4])
        board.place_piece(rook, [7, 7])
        board.place_piece(blocking_pawn, [7, 5])

        board.execute_castling(:white, :kingside)

        # King and rook should remain in their original positions
        expect(board.piece_at([7, 4])).to eq(king)
        expect(board.piece_at([7, 7])).to eq(rook)
        expect(board.piece_at([7, 6])).to be_nil
        expect(king.moved?).to be false
        expect(rook.moved?).to be false
      end
    end
  end
  describe '#execute_en_passant' do
    context 'when a white pawn has an enemy pawn that just advanced two squares beside it' do
      let(:board) { Board.new(setup: false) }
      let(:capturer) { Pawn.new(:white, [3, 4]) }
      let(:victim) { Pawn.new(:black, [1, 3]) }

      before do
        board.place_piece(King.new(:white, [7, 7]), [7, 7])
        board.place_piece(King.new(:black, [0, 7]), [0, 7])
        board.place_piece(capturer, [3, 4])
        board.place_piece(victim, [1, 3])
      end

      it 'allows the capture on the very next move' do
        board.move_piece([1, 3], [3, 3]) # Victim makes double step

        expect(board.valid_move?(capturer, [2, 3])).to be true
      end

      it 'removes the captured pawn from the board' do
        board.move_piece([1, 3], [3, 3])
        board.move_piece([3, 4], [2, 3]) # Capturer executes en passant

        expect(board.piece_at([3, 3])).to be_nil
      end

      it 'puts the capturing pawn on the square the enemy pawn skipped' do
        board.move_piece([1, 3], [3, 3])
        board.move_piece([3, 4], [2, 3])

        expect(board.piece_at([2, 3])).to be(capturer)
      end

      it 'is no longer allowed once any other move has been played' do
        board.move_piece([1, 3], [3, 3])
        board.move_piece([0, 7], [0, 6]) # Some unrelated move

        expect(board.valid_move?(capturer, [2, 3])).to be false
      end

      it 'is not allowed when the enemy pawn arrived by two single steps' do
        middle = [2, 3]
        board.move_piece([1, 3], middle)    # First single step
        board.move_piece([0, 7], [0, 6])    # Unrelated move
        board.move_piece(middle, [3, 3])    # Second single step

        expect(board.valid_move?(capturer, [2, 3])).to be false
      end
    end

    context 'when a black pawn has an enemy pawn that just advanced two squares beside it' do
      let(:board) { Board.new(setup: false) }
      let(:capturer) { Pawn.new(:black, [4, 4]) }
      let(:victim) { Pawn.new(:white, [6, 3]) }

      before do
        board.place_piece(King.new(:white, [7, 7]), [7, 7])
        board.place_piece(King.new(:black, [0, 7]), [0, 7])
        board.place_piece(capturer, [4, 4])
        board.place_piece(victim, [6, 3])
      end

      it 'allows the black capture on the very next move' do
        board.move_piece([6, 3], [4, 3]) # White victim makes double step

        expect(board.valid_move?(capturer, [5, 3])).to be true
      end

      it 'removes the captured white pawn and places the black pawn correctly' do
        board.move_piece([6, 3], [4, 3])
        board.move_piece([4, 4], [5, 3])

        expect(board.piece_at([4, 3])).to be_nil
        expect(board.piece_at([5, 3])).to be(capturer)
      end
    end

    it 'is not allowed when it would expose the capturing side\'s king to check' do
      board = Board.new(setup: false)
      capturer = Pawn.new(:white, [3, 4])

      board.place_piece(King.new(:white, [3, 0]), [3, 0]) # King on same rank, vulnerable to rook
      board.place_piece(King.new(:black, [0, 7]), [0, 7])
      board.place_piece(Rook.new(:black, [3, 7]), [3, 7]) # Rook lining up on the king if pawn leaves
      board.place_piece(capturer, [3, 4])
      board.place_piece(Pawn.new(:black, [1, 3]), [1, 3])

      board.move_piece([1, 3], [3, 3])

      # Moving diagonally here unblocks the rook and exposes the king to check
      expect(board.valid_move?(capturer, [2, 3])).to be false
    end
    it 'is not allowed when the white pawn that just advanced two squares is a friendly pawn' do
      board = Board.new(setup: false)
      capturer = Pawn.new(:white, [4, 4])
      friendly_pawn = Pawn.new(:white, [6, 3])

      board.place_piece(King.new(:white, [7, 7]), [7, 7])
      board.place_piece(King.new(:black, [0, 7]), [0, 7])
      board.place_piece(capturer, [4, 4])
      board.place_piece(friendly_pawn, [6, 3])

      # Friendly white pawn makes a double step
      board.move_piece([6, 3], [4, 3])

      # Capturing a friendly pawn en passant must be blocked
      expect(board.valid_move?(capturer, [5, 3])).to be false
    end

    it 'is not allowed when the black pawn that just advanced two squares is a friendly pawn' do
      board = Board.new(setup: false)
      capturer = Pawn.new(:black, [3, 4])
      friendly_pawn = Pawn.new(:black, [1, 3])

      board.place_piece(King.new(:white, [7, 7]), [7, 7])
      board.place_piece(King.new(:black, [0, 7]), [0, 7])
      board.place_piece(capturer, [3, 4])
      board.place_piece(friendly_pawn, [1, 3])

      # Friendly black pawn makes a double step
      board.move_piece([1, 3], [3, 3])

      # Capturing a friendly pawn en passant must be blocked
      expect(board.valid_move?(capturer, [2, 3])).to be false
    end
  end
end
