require_relative 'colorize_text.rb' #to make colorized strings
module Display_Pins
    TOP_LEFT = "\u2554" #unicode characters to make game board
    TOP_RIGHT = "\u2557"
    BOTTOM_LEFT = "\u255a"
    BOTTOM_RIGHT = "\u255d"
    HOR = "\u2550"
    VER = "\u2551"
    T_DOWN = "\u2566"
    T_UP = "\u2569"
    EMPTY_CIRCLE_SMALL = "\u25ef"
    FILLED_CIRCLE_SMALL = "\u25cf"
    DASHED_CIRCLE_SMALL = "\u25cc"
    FILLED_CIRCLE_LARGE = "\u2b24"
    EMPTY_CIRCLE_LARGE = "\u25CE"
    
    COLORED_CIRCLES = {
        R: FILLED_CIRCLE_LARGE.red,
        G: FILLED_CIRCLE_LARGE.green,
        B: FILLED_CIRCLE_LARGE.blue,
        Y: FILLED_CIRCLE_LARGE.yellow,
        P: FILLED_CIRCLE_LARGE.purple,
        C: FILLED_CIRCLE_LARGE.cyan,
        BL: FILLED_CIRCLE_LARGE.black,

    }

    def print_code(code) #returns a string of just the code, no clues
        "\n" + TOP_LEFT + HOR*13 + TOP_RIGHT + "\n" + VER + " " + COLORED_CIRCLES[code[0].to_sym] + " "*2 + COLORED_CIRCLES[code[1].to_sym] + " "*2 + COLORED_CIRCLES[code[2].to_sym] + " "*2 + COLORED_CIRCLES[code[3].to_sym] + " "*2 + VER + "\n" + BOTTOM_LEFT + HOR*13 + BOTTOM_RIGHT
    end

    def print_board_pins(guess,clues) #prints the whole board, including clues
        puts TOP_LEFT + HOR*13 + + T_DOWN + HOR*9 + TOP_RIGHT 
        puts VER + " " + COLORED_CIRCLES[guess[0].to_sym] + " "*2 + COLORED_CIRCLES[guess[1].to_sym] + " "*2 + COLORED_CIRCLES[guess[2].to_sym] + " "*2 + COLORED_CIRCLES[guess[3].to_sym] + " "*2 + VER + " " + clues[0] + " " +  clues[1] + " " +  clues[2] + " " + clues[3] + " " + VER
        puts BOTTOM_LEFT + HOR*13 + T_UP + HOR*9 + BOTTOM_RIGHT
    end

    def give_clues(code, guesses) # n-time complexity. exact matches are given priority. need to remove elements from temp_code to prevent duplicates
        clues = []
        temp_code = code.clone
        temp_guesses = guesses.clone
        guesses.each_with_index {|guess, index|
            if guess == code[index]
                clues.push(FILLED_CIRCLE_SMALL.red)
                temp_code[index] = nil
                temp_guesses[index] = nil
            end
        }
        temp_guesses.each{|guess|
            next if guess == nil
            if temp_code.include?(guess)
                clues.push(FILLED_CIRCLE_SMALL)
                temp_code[temp_code.index(guess)]=nil
            end
        }
        while clues.length < 4 #make sure 4 clues are given
            clues.push(DASHED_CIRCLE_SMALL)
        end
        clues
    end

    def how_to_play
        puts "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        puts
        puts "Mastermind is a 2-player game. One player is a " +  "CODE SETTER".blue + " and the other is the " + "CODE BREAKER".red
        puts
        puts "The CODE is comprised of 4 pins. Each pin can be one of six colors: " + "RED".red + " " + "BLUE".blue + " " + "GREEN".green + " " + "YELLOW".yellow + " " + "PURPLE".purple + " or " + "CYAN".cyan
        puts
        puts "The CODE " + "SETTER".blue + " gets to set the secret CODE"
        puts
        puts "The CODE " + "BREAKER".red + " gets 12 tries to try and " + "BREAK".red + " the code"
        puts
        puts "After each guess, 'clues' are fed back to the CODE " + "BREAKER ".red + "to provide information on how close the guess is to the secret code"
        puts
        puts "A red clue " + FILLED_CIRCLE_SMALL.red + " corresponds to a correct color pin in the correct location. A white clue " + FILLED_CIRCLE_SMALL + " corresponds to a correct color pin, but not in the correct spot"
        puts
        puts "A clue is left 'empty' for an incorrect pin. The order of the clues given do not correlate to anything."
        puts
        puts "Example board below: The guess is on the left and the clues are on the right. The guess contains 1 correct pin in the correct location, and 2 correct pins in the wrong location"
        print_board_pins(["G","P","P","R"],[FILLED_CIRCLE_SMALL.red, FILLED_CIRCLE_SMALL,FILLED_CIRCLE_SMALL,DASHED_CIRCLE_SMALL])
        puts 
        puts "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        puts
    end

    class Board
        @board = {} #key is the turn number, the value is an array with 2 elements, both of which are arrays. The first element is the guess for that turn, the second element is the clues
        
        def initialize
            @board={}
            i=1;
            until i ==13 do
                @board[i.to_s.to_sym]=[["BL","BL","BL","BL"],[DASHED_CIRCLE_SMALL,DASHED_CIRCLE_SMALL,DASHED_CIRCLE_SMALL,DASHED_CIRCLE_SMALL]] #board starts as with no guesses or clues
                i+=1
            end
        end

        def print_game_board
            @board.each{|k,v|
                print_board_pins(v[0],v[1])
            }
        end

        def update_game_board(guess, clues, turn)
            @board[turn.to_s.to_sym] = [guess, clues]
        end
    end
end