class GameBoard
  attr_accessor :board

  def initialize
    @board = Array.new(8){Array.new(8){Node.new}}
  end

  class Node
    attr_accessor :connections, :position

    def initialize
      @connections = []
      @position = []
    end
  end

  class Knight
    attr_accessor :current_position

    def initialize(current_position = nil)
      @current_position = current_position
    end
  end

  def generate_node_coordinates
    @board.each_with_index do |row, row_index|
      row.each_with_index do |node, node_index|
        node.position << row_index
        node.position << node_index
      end
    end
  end

  def print_board
    @board.each do |row|
      puts row.map {|node| print node.position }.join(" ") #print is optional
    end
  end

  def move_generator_from(node, available_moves = [])
    row, col =  node.position[0], node.position[1]

    #down
    available_moves << [row+2, col+1] if (row+2).between?(0,7) && (col+1).between?(0,7)
    available_moves << [row+2, col-1] if (row+2).between?(0,7) && (col-1).between?(0,7)
    #left
    available_moves << [row+1, col-2] if (row+1).between?(0,7) && (col-2).between?(0,7)
    available_moves << [row-1, col-2] if (row-1).between?(0,7) && (col-2).between?(0,7)
    #up
    available_moves << [row-2, col+1] if (row-2).between?(0,7) && (col+1).between?(0,7)
    available_moves << [row-2, col-1] if (row-2).between?(0,7) && (col-1).between?(0,7)
    #right
    available_moves << [row+1, col+2] if (row+1).between?(0,7) && (col+2).between?(0,7)
    available_moves << [row-1, col+2] if (row-1).between?(0,7) && (col+2).between?(0,7)

    return available_moves
  end

  def node_accessor(coordinates)
    @board[coordinates[0]][coordinates[1]]
  end

end



board = GameBoard.new
board.print_board
board.generate_node_coordinates
board.print_board

node = board.node_accessor([0,4])
moves = board.move_generator_from(node)
puts print moves
