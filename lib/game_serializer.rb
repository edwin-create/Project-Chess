# frozen_string_literal: true

require_relative 'game'
# Save and load games
class GameSerializer
  def initialize(game)
    @game = game
  end

  def save
    # Ensure the saves directory exists
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = generate_filename
    # Serialize the game object and write it to the file
    serialized_data = Marshal.dump(@game)
    File.write(filename, serialized_data)
    filename # Return the filename so the UI/caller knows what was saved
  end

  def self.load(filename)
    Marshal.load(File.read(filename)) # rubocop:disable Security/MarshalLoad
  end

  private

  def generate_filename
    timestamp = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    base_path = "saves/chess_game_#{timestamp}"
    filename = "#{base_path}.sav"

    counter = 2
    while File.exist?(filename)
      filename = "#{base_path}_#{counter}.sav"
      counter += 1
    end

    filename # Explicitly return the filename string at the end!
  end
end
