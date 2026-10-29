# frozen_string_literal: true

require_relative '../lib/rook'
describe Rook do # rubocop:disable Metrics/BlockLength
  let(:rook) { Rook.new(:white, [0, 0]) }

  describe '#initialize' do
    it 'sets the color of the rook' do
      expect(rook.color).to eq(:white)
    end

    it 'sets the position of the rook' do
      expect(rook.position).to eq([0, 0])
    end
  end

  describe '#valid_moves' do
    it 'returns an array of valid moves for the rook' do
      expect(rook.valid_moves).to match_array(
        [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
         [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
      )
    end

    it 'returns all moves from the center of the board' do
      rook = Rook.new(:white, [3, 3])
      expect(rook.valid_moves).to contain_exactly(
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
        [7, 3]
      )
    end
    it 'returns all moves from the edge of the board' do
      rook = Rook.new(:white, [0, 3])
      expect(rook.valid_moves).to contain_exactly(
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
        [7, 3]
      )
    end
  end
  describe '#piece_type' do
    it 'returns the correct piece type' do
      expect(rook.piece_type).to eq(:rook)
    end
  end
end
