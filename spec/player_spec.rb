# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  it 'initializes with a valid color and a stripped name' do
    player = Player.new(:white, '  Alice  ')
    expect(player.color).to eq(:white)
    expect(player.name).to eq('Alice')
  end

  it 'defaults name to the capitalized color when name is omitted' do
    player = Player.new(:black)
    expect(player.color).to eq(:black)
    expect(player.name).to eq('Black')
  end

  it 'raises an ArgumentError for invalid colors or invalid names' do
    expect { Player.new(:blue, 'Alice') }.to raise_error(ArgumentError)
    expect { Player.new(:white, '') }.to raise_error(ArgumentError)
    expect { Player.new(:white, 123) }.to raise_error(ArgumentError)
  end
end
