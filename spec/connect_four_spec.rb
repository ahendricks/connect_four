require 'spec_helper'

describe ConnectFour do

  describe "#new" do
    before(:all) { @game = ConnectFour.new }

    it "has a board with 7 columns of 6" do
      dimensions = [@game.board.length, @game.board[0].length]
      expect(dimensions).to eq([7,6])
    end

    it "has a red player" do
      @game.player1 = :red
    end

    it "has a black player" do
      @game.player2 = :black
    end

    it "starts the game on red player's turn" do
      expect(@game.current_player).to eq(@game.player1)
    end
  end

  describe "#add_piece" do
    before(:all) do
      @game = ConnectFour.new
    end

    context "when column is not full" do
      it "adds a piece to the first slot in an empty column" do
        @game.add_piece(:red, 3)
        expect(@game.board[3][0]).to eq(:red)
      end

      it "adds a piece to the first open slot in a non-empty column" do
        @game.add_piece(:black, 3)
        expect(@game.board[3][1]).to eq(:black)
      end
    end

    context "when column is full" do
      it "does not add a piece" do
        7.times { @game.add_piece(:red, 2) }
        @game.add_piece(:black, 2)
        expect(@game.board[2]).to_not include(:black)
      end
    end
  end

  describe "#check_for_winner" do
    before(:each) { @game = ConnectFour.new }

    it "recognizes 4 vertical of same color" do
      2.times { @game.add_piece(:red, 0) } 
      4.times { @game.add_piece(:black, 0) }
      expect(@game.check_for_winner).to eq(:black)
    end

    it "recgonizes 4 horizontal of the same color" do
      4.times { |i| @game.add_piece(:red, i) }
      expect(@game.check_for_winner).to eq(:red)
    end

    it "recognizes 4 diagonal right of the same color" do
      3.times { @game.add_piece(:red, 3) } 
      3.times do |i|
        (i+1).times { @game.add_piece(:black, i) }
      end
      @game.add_piece(:black, 3)
      expect(@game.check_for_winner).to eq(:black)
    end

    it "recognizes 4 diagonal left of the same color" do
      3.times { @game.add_piece(:red, 3) }
      3.times do |i|
        (i+1).times { @game.add_piece(:black, (6-i)) }
      end
      @game.add_piece(:black, 3)
      expect(@game.check_for_winner).to eq(:black)
    end

    it "returns false when there is no winner" do
      expect(@game.check_for_winner).to eq(false)
    end
  end

  describe "#switch_player" do
    it "switches current_player to the other player" do
      game = ConnectFour.new
      original_player = game.current_player
      game.switch_player
      expect(game.current_player).to_not eq(original_player)
    end
  end

  describe "#input_valid?" do
    before(:all) { @game = ConnectFour.new }

    it "rejects non-integer input" do
      input = "a"
      expect(@game.input_valid?(input)).to eq(false)
    end

    it "rejects input with more than 1 digit" do
      input = "11"
      expect(@game.input_valid?(input)).to eq(false)
    end

    it "rejects input with less than 1 digit" do
      input = ""
      expect(@game.input_valid?(input)).to eq(false)
    end

    it "rejects integers that don't correspond with a column" do
      input = "9"
      expect(@game.input_valid?(input)).to eq(false)
    end

    it "accepts a single digit" do
      input = "1"
      expect(@game.input_valid?(input)).to eq(true)
    end
  end
end