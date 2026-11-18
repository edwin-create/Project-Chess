# frozen_string_literal: true

# Represents a chess player in the game.
# Each player has a name and a color (for example, :white or :black).
class Player
  attr_reader :name, :color

  # Initializes a player with a chosen color and name.
  def initialize(color, name = color.to_s.capitalize)
    raise ArgumentError, 'Player name must be a non-empty string' unless %i[white black].include?(color)
    if name.nil? || !name.is_a?(String) || name.strip.empty?
      raise ArgumentError,
            'Player name must not be empty or a number'
    end

    @color = color
    @name = name.strip
  end
end
