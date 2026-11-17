# frozen_string_literal: true

require_relative '../lib/game'
require 'spec_helper'

RSpec.describe Game do
  let(:game) { described_class.new }
  let(:white_player) { double('White player', color: :white) }
  let(:black_player) { double('Black player', color: :black) }

  describe '#initialize' do
    subject(:game) { described_class.new(white_player, black_player) }

    it 'stores the two players' do
      expect(game.white_player).to equal(white_player)
      expect(game.black_player).to equal(black_player)
    end

    it 'creates a board' do
      expect(game.board).to be_a(Board)
    end

    it 'sets the white player as the current player' do
      expect(game.current_player).to equal(white_player)
    end

    it 'raises an ArgumentError if the first player is not White' do
      expect do
        described_class.new(double('Not white', color: :black), black_player)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if the second player is not Black' do
      expect do
        described_class.new(white_player, double('Not black', color: :white))
      end.to raise_error(ArgumentError)
    end
  end
  describe '#switch_turn' do
    it 'switches the current player from white to black' do
      game = Game.new

      # Verify it starts with the white player
      expect(game.current_player).to eq(game.white_player)

      game.switch_turn

      # Verify it switched to the black player
      expect(game.current_player).to eq(game.black_player)
    end

    it 'switches the current player from black back to white' do
      game = Game.new

      # Switch once to get to black
      game.switch_turn
      expect(game.current_player).to eq(game.black_player)

      # Switch a second time to return to white
      game.switch_turn
      expect(game.current_player).to eq(game.white_player)
    end
  end
  describe '#play' do # rubocop:disable Metrics/BlockLength
    let(:pawn_double) { double('Pawn') }

    before do
      # Provide a default stub for last_move so standard tests don't return nil
      allow(game.board).to receive(:last_move).and_return(piece: pawn_double)
      allow(game.board).to receive(:promotion_allowed?).and_return(false)
    end

    it 'processes "e2 e4" and passes [6, 4] and [4, 4] to the board' do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:gets).and_return("e2 e4\n")

      expect(game.board).to receive(:move_piece).with([6, 4], [4, 4])

      game.play
    end

    it 'processes "a8 h1" and passes [0, 0] and [7, 7] to the board' do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:gets).and_return("a8 h1\n")

      expect(game.board).to receive(:move_piece).with([0, 0], [7, 7])

      game.play
    end

    it 'tolerates extra whitespace in the user input' do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:gets).and_return("   e2    e4   \n")

      expect(game.board).to receive(:move_piece).with([6, 4], [4, 4])

      game.play
    end

    it 'recovers from invalid or incomplete moves without crashing the loop' do
      allow(game).to receive(:game_over?).and_return(false, false, true)
      allow(game).to receive(:gets).and_return("e2 e9\n", "e2 e4\n")

      expect(game.board).to receive(:move_piece).with([6, 4], [4, 4]).once

      game.play
    end

    it 'switches the player after a successful move' do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:gets).and_return("e2 e4\n")
      allow(game.board).to receive(:move_piece)

      expect { game.play }.to(change { game.current_player })
    end

    it 'does not switch players when an invalid move is entered' do
      allow(game).to receive(:game_over?).and_return(false, false, true)
      allow(game).to receive(:gets).and_return("e2 e9\n", "e2 e4\n")
      allow(game.board).to receive(:move_piece)

      expect(game).to receive(:switch_turn).once

      game.play
    end

    it 'prompts for a choice and executes promotion when allowed' do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:gets).and_return("e7 e8\n", "q\n")

      allow(game.board).to receive(:move_piece)
      allow(game.board).to receive(:promotion_allowed?).with(pawn_double).and_return(true)

      expect(game.board).to receive(:execute_promotion).with(pawn_double, :queen)

      game.play
    end

    it 'skips promotion when not allowed' do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(game).to receive(:gets).and_return("e2 e4\n")

      allow(game.board).to receive(:move_piece)
      allow(game.board).to receive(:promotion_allowed?).with(pawn_double).and_return(false)

      expect(game.board).not_to receive(:execute_promotion)

      game.play
    end
  end
end
