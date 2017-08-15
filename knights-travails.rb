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

  #function works, move counting is wrong, do that and it's a GG
  #a modified BFS algorithm #start= root, end=searched_value
  def knight_moves(start, ends, queue=[])
    root = node_accessor(start) #finds the node with start coordinates
    final = node_accessor(ends)
    moves_array = []

    queue << root
    while queue.size > 0
      potential = queue.shift
      #puts print potential.position #not needed, delete at end
      if potential.position == final.position
        while potential.parent
          moves_array << potential
          potential = potential.parent
        end
        return moves_array
      else
        potential.connections.each do |coordinates|
          child_node = node_accessor(coordinates)
          child_node.parent = potential
          queue << child_node
        end
      end
    end
  end

  #delete at end, only for reference
  def breadth_first_search(root, searched_value, queue=[])
    queue << root
    while queue.size > 0
      #line below needed just for debugging
      #puts print queue.map {|node| node.value}
      potential = queue.shift
      if potential.value == searched_value
        return potential
      else
        queue << potential.left_child unless potential.left_child.nil?
        queue << potential.right_child unless potential.right_child.nil?
      end
    end
    return nil if queue.size == 0
  end


end



board = GameBoard.new
board.print_board
board.generate_node_coordinates
board.print_board

board.generate_network
result = board.knight_moves([0,0], [3,3]) #result is an array
result.reverse!.each {|move| puts print move}
