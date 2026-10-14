require_relative '../lib/piece'

describe Piece do
  let(:piece) { Piece.new(:white, [0, 0]) }

  describe '#initialize' do
    it 'sets the color of the piece' do
      expect(piece.color).to eq(:white)
    end

    it 'sets the position of the piece' do
      expect(piece.position).to eq([0, 0])
    end
  end
end
