# frozen_string_literal: true

require_relative '../lib/display'

describe Display do # rubocop:disable Metrics/BlockLength
  let(:display) { Display.new }

  describe '#introduction' do
    it 'displays the introduction message' do
      expect do
        display.introduction
      end.to output("Welcome to Chess!\nPlayers take turns moving pieces around the board.\nThe first player to checkmate their opponent wins!\n").to_stdout
    end
  end

  describe '#render' do
    it 'renders the horizontal border' do
      board = Array.new(8) { Array.new(8) }

      expect(display.render(board)).to include('+----+---+---+---+---+---+---+---+')
    end

    it 'renders the column labels' do
      board = Array.new(8) { Array.new(8) }

      expect(display.render(board)).to include('    a   b   c   d   e   f   g   h')
    end
    it 'renders the square colors in the correct order' do
      board = Array.new(8) { Array.new(8) }
      output = display.render(board)
      rank_8 = output.lines[2] # rubocop:disable Naming/VariableNumber

      light_code = "\e[48;2;240;217;181m"
      dark_code = "\e[48;2;181;136;99m"

      expect(rank_8.index(light_code)).to be < rank_8.index(dark_code)
    end
  end
end
