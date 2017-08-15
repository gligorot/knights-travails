class GameBoard
  attr_accessor :board

  def initialize
    @board = Array.new(8){Array.new(8){Node.new}}
  end

  class Node
    attr_accessor :connections, :position, :parent

    def initialize
      @connections = []
      @position = []

      @parent = nil
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

    #up
    available_moves << [row-2, col+1] if (row-2).between?(0,7) && (col+1).between?(0,7)
    available_moves << [row-2, col-1] if (row-2).between?(0,7) && (col-1).between?(0,7)
    #right
    available_moves << [row+1, col+2] if (row+1).between?(0,7) && (col+2).between?(0,7)
    available_moves << [row-1, col+2] if (row-1).between?(0,7) && (col+2).between?(0,7)
    #down
    available_moves << [row+2, col+1] if (row+2).between?(0,7) && (col+1).between?(0,7)
    available_moves << [row+2, col-1] if (row+2).between?(0,7) && (col-1).between?(0,7)
    #left
    available_moves << [row+1, col-2] if (row+1).between?(0,7) && (col-2).between?(0,7)
    available_moves << [row-1, col-2] if (row-1).between?(0,7) && (col-2).between?(0,7)

    return available_moves
  end


  def node_accessor(coordinates)
    @board[coordinates[0]][coordinates[1]] #@board[row][col]
  end

  def generate_network
    @board.each do |row|
      row.each do |node|
        node.connections = move_generator_from(node)
        #puts print node.connections #not needed in final code
      end
    end
  end

  #a modified BFS algorithm #start= root, end=searched_value
  def knight_moves(start, ends, queue=[], moves_array=[])
    root = node_accessor(start) #finds the node with start coordinates
    final = node_accessor(ends)

    queue << root
    while queue.size > 0
      potential = queue.shift
      if potential.position == final.position
        until potential == root
          moves_array << potential.position
          potential = potential.parent
        end
        moves_array << root.position
        puts "The knight got the the queen in #{moves_array.size} moves! Here's the path: "
        moves_array.each {|move| puts print move}
        return
      else
        potential.connections.each do |coordinates|
          child_node = node_accessor(coordinates)
          child_node.parent = potential
          queue << child_node
        end
      end
    end
  end

end



board = GameBoard.new
board.print_board
board.generate_node_coordinates
board.print_board

board.generate_network
board.knight_moves([0,0], [3,3])
