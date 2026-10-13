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
end
