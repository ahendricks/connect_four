class ConnectFour
  attr_accessor :board, :player1, :player2, :current_player

  def initialize
    @board = create_board
    @player1 = :red
    @player2 = :black
    @current_player = player1
  end

  def create_board
    7.times.map{ 6.times.map{0} }
  end

  def game_loop
    while check_for_winner == false
      turn_executed = false
      while turn_executed == false
        input = ""
        display_board
        while input_valid?(input) == false
          puts @current_player.to_s + " player, choose a column:"
          input = gets.chomp
          if !input_valid?(input)
            puts "Invalid input. Please choose an existing column."
          else
            if add_piece(@current_player, input.to_i)
              turn_executed = true
              switch_player
            else
              puts "Slot already taken!"
            end
          end
        end
      end
    end
    display_board
    switch_player
    puts "#{@current_player.to_s} player wins!"
  end

  def add_piece(player, column)
    first_open_slot = board[column].index{ |slot| slot == 0 }
    if !first_open_slot.nil?
      @board[column][first_open_slot] = player
    else
      false
    end
  end

  def switch_player
    @current_player = @current_player == player1 ? player2 : player1  
  end

  def check_for_winner
    check_columns || check_rows || check_diagonal_right || check_diagonal_left
  end

  def input_valid?(input)
    input =~ /^\d$/ && !@board[input.to_i].nil? ? true : false
  end

  def check_columns
    check_transformation(@board)
  end

  def check_rows
    check_transformation(@board.transpose)
  end

  def check_diagonals(board_transformation)
    diagonals = []
    diagonals << (0..5).collect { |i| board_transformation[i][i] }
    diagonals << (0..4).collect { |i| board_transformation[i][i+1] }
    diagonals << (0..3).collect { |i| board_transformation[i][i+2] }

    diagonals << (1..6).collect { |i| board_transformation[i][i-1] }
    diagonals << (2..6).collect { |i| board_transformation[i][i-2] }
    diagonals << (3..6).collect { |i| board_transformation[i][i-3] }
    check_transformation(diagonals)
  end

  def check_diagonal_right
    check_diagonals(@board)
  end

  def check_diagonal_left
    check_diagonals(@board.reverse)
  end  

  def check_transformation(transformation) 
    winner = nil
    transformation.each do |set|
      consecutive = 1
      set.each_with_index do |slot, i|
        unless i == 0
          if slot == set[i-1] && slot != 0
            consecutive += 1
            winner = slot if consecutive == 4
          else
            consecutive = 1
          end
        end
      end
    end
    winner ? winner : false
  end

  def display_board
    puts "0 1 2 3 4 5 6"
    6.times do |i|
      level = i
      @board.each do |column|
        print sym_to_char(column[5-level]) + " "
      end
       print "\n"
    end
  end

  def sym_to_char(sym)
    hash = { :red => "\u{26AA}", :black => "\u{26AB}", 0 => "\u{25E1}" }
    hash[sym]
  end
end