require_relative '../lib/queen'
describe Queen do # rubocop:disable Metrics/BlockLength
  let(:queen) { Queen.new(:white, [0, 0]) }

  describe '#initialize' do
    it 'sets the color of the queen' do
      expect(queen.color).to eq(:white)
    end

    it 'sets the position of the queen' do
      expect(queen.position).to eq([0, 0])
    end
  end

  describe '#valid_moves' do
    it 'returns an array of valid moves for the queen' do
      expect(queen.valid_moves).to match_array(
        [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
         [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
         [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
      )
    end

    it 'returns all moves from the center of the board' do
      queen = Queen.new(:white, [3, 3])
      expect(queen.valid_moves).to contain_exactly(
        # Rook moves
        [3, 0],
        [3, 1],
        [3, 2],
        [3, 4],
        [3, 5],
        [3, 6],
        [3, 7],
        [0, 3],
        [1, 3],
        [2, 3],
        [4, 3],
        [5, 3],
        [6, 3],
        [7, 3],
        # Bishop moves
        [4, 4],
        [5, 5],
        [6, 6],
        [7, 7],
        [2, 2],
        [1, 1],
        [0, 0],
        [4, 2],
        [5, 1],
        [6, 0],
        [2, 4],
        [1, 5],
        [0, 6]
      )
    end

    it 'returns all moves from the edge of the board' do
      queen = Queen.new(:white, [0, 3])
      expect(queen.valid_moves).to contain_exactly(
        # Rook moves
        [0, 0],
        [0, 1],
        [0, 2],
        [0, 4],
        [0, 5],
        [0, 6],
        [0, 7],
        [1, 3],
        [2, 3],
        [3, 3],
        [4, 3],
        [5, 3],
        [6, 3],
        [7, 3],
        # Bishop moves
        [1, 4],
        [2, 5],
        [3, 6],
        [4, 7],
        [1, 2],
        [2, 1],
        [3, 0]
      )
    end
  end
end
