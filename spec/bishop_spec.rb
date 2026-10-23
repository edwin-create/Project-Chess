# frozen_string_literal: true

require_relative '../lib/bishop'
describe Bishop do # rubocop:disable Metrics/BlockLength
  let(:bishop) { Bishop.new(:white, [0, 0]) }

  describe '#initialize' do
    it 'sets the color of the bishop' do
      expect(bishop.color).to eq(:white)
    end

    it 'sets the position of the bishop' do
      expect(bishop.position).to eq([0, 0])
    end
  end

  describe '#valid_moves' do # rubocop:disable Metrics/BlockLength
    it 'returns an array of valid moves for the bishop' do
      expect(bishop.valid_moves).to match_array(
        [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
      )
    end

    it 'returns all moves from the center of the board' do
      bishop = Bishop.new(:white, [3, 3])
      expect(bishop.valid_moves).to contain_exactly(
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
      bishop = Bishop.new(:white, [0, 3])
      expect(bishop.valid_moves).to contain_exactly(
        [1, 4], [2, 5], [3, 6], [4, 7],
        [1, 2], [2, 1], [3, 0]
      )
    end
  end
end
