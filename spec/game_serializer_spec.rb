# frozen_string_literal: true

require_relative '../lib/game_serializer'
require_relative '../lib/game'
require 'fileutils'

RSpec.describe GameSerializer do
  let(:game) { Game.new }
  let(:serializer) { described_class.new(game) }

  after { FileUtils.rm_rf('saves') }

  it 'creates a save file on disk' do
    filename = serializer.save
    expect(File.exist?(filename)).to be true
  end

  it 'avoids overwriting by using a suffix on collision' do
    fixed_time = Time.now
    allow(Time).to receive(:now).and_return(fixed_time)

    file1 = serializer.save
    file2 = serializer.save

    expect(file1).not_to eq(file2)
    expect(File.exist?(file1)).to be true
    expect(File.exist?(file2)).to be true
  end
  it 'restores the current players turn' do
    # Use the public interface to make a valid move.
    # This automatically triggers the turn change to :black.
    game.switch_turn

    filename = serializer.save
    loaded_game = GameSerializer.load(filename)

    expect(loaded_game).to be_a(Game)
    expect(loaded_game.current_player.color).to eq(:black)
  end
end
