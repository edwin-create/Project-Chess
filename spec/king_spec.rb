require_relative '../lib/king'
describe King do # rubocop:disable Metrics/BlockLength
  let(:king) { King.new(:white, [0, 0]) }
  describe '#initialize' do
    it 'initializes a king with the correct color and position' do
      expect(king.color).to eq(:white)
      expect(king.position).to eq([0, 0])
    end
  end
  describe '#valid_moves' do # rubocop:disable Metrics/BlockLength
    it 'returns an array of valid moves for the king' do
      expect(king.valid_moves).to match_array([[0, 1], [1, 0], [1, 1]])
    end
    it 'returns all 8 moves from the center of the board' do
      king = King.new(:white, [3, 3])
      expect(king.valid_moves).to contain_exactly(
        [2, 2],
        [2, 3],
        [2, 4],
        [3, 2],
        [3, 4],
        [4, 2],
        [4, 3],
        [4, 4]
      )
    end
    it 'returns all valid moves from the edge of the board' do
      king = King.new(:white, [0, 3])
      expect(king.valid_moves).to contain_exactly(
        [0, 2],
        [0, 4],
        [1, 2],
        [1, 3],
        [1, 4]
      )
    end
  end
  describe '#piece_type' do
    it 'returns the correct piece type' do
      expect(king.piece_type).to eq(:king)
    end
  end
end
