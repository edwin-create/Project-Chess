# frozen_string_literal: true

require_relative '../lib/knight'
describe Knight do # rubocop:disable Metrics/BlockLength
  let(:knight) { Knight.new(:white, [0, 0]) }

  describe '#initialize' do
    it 'sets the color of the knight' do
      expect(knight.color).to eq(:white)
    end

    it 'sets the position of the knight' do
      expect(knight.position).to eq([0, 0])
    end
  end
  describe '#valid_moves' do
    it 'returns an array of valid moves for the knight' do
      expect(knight.valid_moves).to match_array([[2, 1], [1, 2]])
    end
    it 'returns all 8 moves from the center of the board' do
      knight = Knight.new(:white, [3, 3])
      expect(knight.valid_moves).to contain_exactly(
        [5, 4],
        [5, 2],
        [1, 4],
        [1, 2],
        [4, 5],
        [4, 1],
        [2, 5],
        [2, 1]
      )
    end
    it 'returns all 4 moves from the edge of the board' do
      knight = Knight.new(:white, [0, 3])
      expect(knight.valid_moves).to contain_exactly(
        [2, 4],
        [2, 2],
        [1, 5],
        [1, 1]
      )
    end
  end
  describe '#piece_type' do
    it 'returns the correct piece type' do
      expect(knight.piece_type).to eq(:knight)
    end
  end
end
