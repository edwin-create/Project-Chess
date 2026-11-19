require_relative 'lib/board'
require_relative 'lib/display'
require_relative 'lib/game'
require_relative 'lib/game_serializer'
require_relative 'lib/player'

def introduction
  puts "\n===================="
  puts '  Welcome to Chessy! '
  puts '===================='
  puts '1. New game'
  puts '2. Load saved game'
  puts '3. Exit'
  print 'Enter number 1, 2, or 3: '
  gets&.chomp&.strip
end

def start_game # rubocop:disable Metrics/MethodLength
  display = Display.new
  display.introduction
  loop do
    case introduction
    when '1'
      white_player, black_player = capture_player_names
      game = Game.new(white_player, black_player)
      game.play

    when '2'
      load_saved_game

    when '3'
      puts 'Goodbye!'
      exit
    when nil
      return
    else
      puts "\n[!] Invalid selection. Please choose 1, 2, or 3."
      # The loop automatically repeats here instead of calling start_game again
    end
  end
end

def load_saved_game # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  files = Dir.glob('saves/*')
  if files.empty?
    puts 'No saved files to load'
    return
  end

  files.each.with_index(1) { |file, i| puts "#{i}. #{File.basename(file)}" }
  print 'Choose a file number: '
  choice = gets
  return if choice.nil?

  index = choice.to_i
  return unless index.between?(1, files.size)

  GameSerializer.load(files[index - 1]).play
end

def capture_player_names # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  puts "What is white's name?"
  name = gets
  white_player = if name.nil?
                   Player.new(:white)
                 elsif name.strip.empty?
                   Player.new(:white)
                 else
                   Player.new(:white, name.chomp)
                 end

  puts "What is black's name?"
  name = gets
  black_player = if name.nil?
                   Player.new(:black)
                 elsif name.strip.empty?
                   Player.new(:black)
                 else
                   Player.new(:black, name.chomp)
                 end
  [white_player, black_player]
end
start_game
