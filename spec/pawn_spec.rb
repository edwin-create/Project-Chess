require_relative '../lib/pawn'

describe Pawn do # rubocop:disable Metrics/BlockLength
  let(:white_pawn) { Pawn.new(:white, [6, 0]) }
  let(:black_pawn) { Pawn.new(:black, [1, 0]) }

  describe '#initialize' do
    it 'sets the correct position for the white pawn' do
      expect(white_pawn.position).to eq([6, 0])
    end

    it 'sets the correct color for the white pawn' do
      expect(white_pawn.color).to eq(:white)
    end
  end

  describe '#valid_moves' do
    it 'returns valid moves for the white pawn' do
      expect(white_pawn.valid_moves).to match_array([[5, 0], [4, 0]])
    end

    it 'returns valid moves for the black pawn' do
      expect(black_pawn.valid_moves).to match_array([[2, 0], [3, 0]])
    end
  end

  describe '#capture_moves' do
    it 'returns valid capture moves for the white pawn' do
      expect(white_pawn.capture_moves).to match_array([[5, 1]])
    end

    it 'returns valid capture moves for the black pawn' do
      expect(black_pawn.capture_moves).to match_array([[2, 1]])
    end
  end
  describe '#piece_type' do
    it 'returns the correct piece type' do
      expect(white_pawn.piece_type).to eq(:pawn)
    end
  end
end
