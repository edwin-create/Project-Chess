# frozen_string_literal: true

require_relative '../lib/display'

describe Display do
  let(:display) { Display.new }

  describe '#introduction' do
    it 'displays the introduction message' do
      expect do
        display.introduction
      end.to output("Welcome to Chess!\nPlayers take turns moving pieces around the board.\nThe first player to checkmate their opponent wins!\n").to_stdout
    end
  end
  describe '#square_color' do
    xit 'returns :light for even row and column' do
      expect(display.square_color(0, 0)).to eq(:light)
    end

    xit 'returns :light for odd row and column' do
      expect(display.square_color(1, 1)).to eq(:light)
    end

    xit 'returns :dark for even row and odd column' do
      expect(display.square_color(0, 1)).to eq(:dark)
    end

    xit 'returns :dark for odd row and even column' do
      expect(display.square_color(1, 0)).to eq(:dark)
    end
  end
  describe '#render' do
    it 'renders the horizontal border' do
      board = Array.new(8) { Array.new(8) }

      expect(display.render(board)).to include('+---+---+---+---+---+---+---+---+')
    end

    it 'renders the column labels' do
      board = Array.new(8) { Array.new(8) }

      expect(display.render(board)).to include('    a   b   c   d   e   f   g   h')
    end
  end
end
