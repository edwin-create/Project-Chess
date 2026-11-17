# frozen_string_literal: true

# Represents a chess player in the game.
# Each player has a name and a color (for example, :white or :black).
class Player
  attr_reader :name, :color

  # Initializes a player with a chosen color and name.
  def initialize(color, name = color.capitalize)
    @color = color
    @name = name
  end
end
