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
  describe '#valid_move? for pawns' do
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
  describe '#valid_move? for kings' do
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
    it 'allows a king to capture an opponent piece' do
      board.move_piece([1, 4], [2, 4])

      board.move_piece([6, 5], [5, 5])
      board.move_piece([5, 5], [4, 5])
      board.move_piece([4, 5], [3, 5])
      board.move_piece([3, 5], [2, 5])

      board.move_piece([0, 4], [1, 4])

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
end
