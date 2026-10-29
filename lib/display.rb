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
    render_rows(output)
    output << column_labels
    output << "\n"
    output
  end

  private

  def render_rows(output) # rubocop:disable Metrics/MethodLength
    # We display ranks from 8 down to 1 for the board, but the board itself is stored
    # with zero-based indexes in arrays, so row 8 becomes index 7 and row 1 becomes index 0.
    # That is why we pass row - 1 into render_square: the printed rank is 1-based, but
    # the internal board coordinates are 0-based.
    8.downto(1) do |row|
      output << "#{row} | "

      # The column loop starts at 0 because Ruby arrays and board positions are zero-indexed.
      # This matches the coordinate system used by square_color and render_square.
      8.times do |col|
        output << render_square(row - 1, col)
        output << '|'
      end

      output << " #{row}"
      output << "\n"
      output << horizontal_border
      output << "\n"
    end
  end

  def square_color(row, col)
    if (row + col).even?
      :light
    else
      :dark
    end
  end

  def render_square(row, col)
    color = square_color(row, col)
    case color
    when :light
      "\e[48;2;240;217;181m   \e[0m"
    when :dark
      "\e[48;2;181;136;99m   \e[0m"
    end
  end

  def horizontal_border
    '  +---+---+---+---+---+---+---+---+'
  end

  def column_labels
    '    a   b   c   d   e   f   g   h'
  end
end
