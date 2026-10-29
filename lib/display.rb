# frozen_string_literal: true

require_relative 'board'
# Class responsible for displaying messages to the user
class Display
  def introduction
    puts 'Welcome to Chess!'
    puts 'Players take turns moving pieces around the board.'
    puts 'The first player to checkmate their opponent wins!'
  end

  def render(board)
    output = String.new
    output << column_labels
    output << "\n"
    output << horizontal_border
    output << "\n"
    render_row(output)
    output << column_labels
    output << "\n"
    output
  end

  private

  def square_color(row, col)
    (row + col).even? ? :light : :dark
  end

  def render_row(output)
    8.downto(1) do |row|
      output << "#{row} |   |   |   |   |   |   |   |   | #{row}"

      output << "\n"
      output << horizontal_border
      output << "\n"
    end
  end

  def horizontal_border
    '  +---+---+---+---+---+---+---+---+'
  end

  def column_labels
    '    a   b   c   d   e   f   g   h'
  end
end
