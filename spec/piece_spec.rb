# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do # rubocop:disable Metrics/BlockLength
  let(:piece) { Piece.new(:white, [0, 0]) }

  describe '#initialize' do
    it 'sets the color of the piece' do
      expect(piece.color).to eq(:white)
    end

    it 'sets the position of the piece' do
      expect(piece.position).to eq([0, 0])
    end
    it 'freezes the position array' do
      piece = Piece.new(:white, [0, 0])

      expect(piece.position).to be_frozen
    end
    it 'raises an error for an invalid starting position' do
      expect { Piece.new(:white, [8, 0]) }.to raise_error(ArgumentError)
    end
  end

  describe '#update_position' do # rubocop:disable Metrics/BlockLength
    it 'updates the position of the piece' do
      piece.update_position([1, 1])
      expect(piece.position).to eq([1, 1])
    end

    it 'raises an error for an invalid position' do
      expect { piece.update_position([-1, 0]) }.to raise_error(ArgumentError)
      expect { piece.update_position([0, -1]) }.to raise_error(ArgumentError)
      expect { piece.update_position([8, 0]) }.to raise_error(ArgumentError)
      expect { piece.update_position([0, 8]) }.to raise_error(ArgumentError)
    end
    it 'allows the piece to move by replacing the position with a new frozen array' do
      piece = Piece.new(:white, [0, 0])

      piece.update_position([1, 2])

      expect(piece.position).to eq([1, 2])
      expect(piece.position).to be_frozen
    end
    it 'leaves the old position untouched when an update fails' do
      piece = Piece.new(:white, [0, 0])

      expect { piece.update_position([-1, 0]) }.to raise_error(ArgumentError)

      expect(piece.position).to eq([0, 0])
    end
    it 'protects the pieces position from external modification.' do
      pos = [0, 0]
      piece = Piece.new(:white, pos)
      pos[0] = 3
      pos[1] = 3

      expect(piece.position).to eq([0, 0])
    end
    it 'prevents in-place mutation of the coordinate' do
      piece = Piece.new(:white, [0, 0])

      expect do
        piece.position[0] = 1
      end.to raise_error(FrozenError)
    end
  end
  describe '#symbol' do
    it 'returns the correct symbol for a white pawn' do
      white_pawn = Pawn.new(:white, [0, 0])
      expect(white_pawn.symbol).to eq('♙')
    end

    it 'returns the correct symbol for a black pawn' do
      black_pawn = Pawn.new(:black, [0, 0])
      expect(black_pawn.symbol).to eq('♟')
    end
    it 'returns the correct symbol for a white knight' do
      white_knight = Knight.new(:white, [0, 0])
      expect(white_knight.symbol).to eq('♘')
    end
    it 'returns the correct symbol for a black knight' do
      black_knight = Knight.new(:black, [0, 0])
      expect(black_knight.symbol).to eq('♞')
    end
  end
end
