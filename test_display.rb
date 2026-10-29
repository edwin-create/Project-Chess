require_relative 'lib/display'
board = Array.new(8) { Array.new(8) }
display = Display.new
puts display.render(board)
