require_relative 'colorize_text.rb'
require_relative 'display_pins.rb'
include Display_Pins
module Mastermind
    VALID_GUESSES =['R','G','B','Y','P','C'] #only playable characters

    class Game
        @game_won
        @game_mode
        @game_board = Board.new;
        @code = []
        
        def initialize
            mode_select
        end

        def mode_select
            @game_mode = main_menu
            case @game_mode
                when '1' then play_breaker
                when '2' then play_setter
                when '3' then how_to_play ; mode_select
                when '4' then return
            end
        end

        def main_menu
            game_mode = nil
            message = "Welcome to Mastermind! Please enter a number (1-4) to choose an option"
            until (game_mode == '1' || game_mode == '2' || game_mode == '3' || game_mode == '4') do
                puts message
                puts "1. Play as Code " + "BREAKER".red
                puts "2. Play as Code " + "SETTER".blue
                puts "3. How to play"
                puts "4. Quit"
                game_mode = gets.chomp
                message = "You did not select a valid otpion. Please enter a number (1-4) to choose an option"
            end
            game_mode
        end

        def check_win(clues)
            @game_won = clues.all?{|clue| clue == Display_Pins::FILLED_CIRCLE_SMALL.red}
        end

        def play_setter
            @turn_number=1
            @game_won = false
            @game_board = Board.new
            @code = input('Please enter your code(example:RCBY): ')
            puts print_code(@code)
            @computer = ComputerPlayer.new
            clues = nil
            until (@game_won || @turn_number > 12) do
                @turn_number == 1 ? guess = ['R' , 'R' , 'B' , 'B'] : guess=@computer.new_guess(guess,clues)
                clues = give_clues(@code,guess)
                @game_board.update_game_board(guess,clues,@turn_number)
                @game_board.print_game_board
                puts "-------------------------------\n"
                check_win(clues)
                sleep 1.25
                puts "Sorry, you lost! The computer figured out the code! The code was: " + print_code(@code) if @game_won
                @turn_number+=1
                puts "Congratulations! You won! The computer did not figure out your code! The code was: " + print_code(@code) if @turn_number > 12
            end
            mode_select
        end

        def play_breaker
            @turn_number = 1;
            @game_won = false
            @game_board = Board.new
            @game_board.print_game_board
            @computer = ComputerPlayer.new
            @code = @computer.make_code
            until (@game_won || @turn_number > 12) do
                puts "WARNING! CHOOSE WISELY! THIS IS YOUR LAST TRY!".red if @turn_number == 12
                guess = input('Please enter your four guesses(example: RCBY): ')
                clues = give_clues(@code,guess)
                @game_board.update_game_board(guess,clues,@turn_number)
                @game_board.print_game_board
                check_win(clues)
                puts "Congratulations, you won!" if @game_won
                @turn_number+=1
                puts "Sorry, you lost! The code was:" + print_code(@code) if @turn_number > 12
            end
            mode_select
        end
    end

    class ComputerPlayer
        
        @@set_of_all_combinations = []

        def initialize
            @@set_of_all_combinations = VALID_GUESSES.repeated_permutation(4).to_a
        end
        
        def new_guess(guess,clues) #based on Donal Knuth's algorithm, which shrinks the set of all possible combinations based on the clues
            @@set_of_all_combinations = @@set_of_all_combinations.select{|combo| 
                give_clues(guess,combo) == clues
            }
            @@set_of_all_combinations.sample
        end

        def make_code
            @@set_of_all_combinations.sample #randomly select a code
        end
    end

    def input(message) #reusable input for player to enter guesses or to set code
        guesses =''
        while !(guesses.split('').all?{|guess| VALID_GUESSES.include?(guess)} && guesses.length == 4)
            print message; guesses=gets.chomp
            message = 'You entered incorrect letters or the wrong number of guesses. Please try again(example: RBPG): '
        end
        guesses.split("")
    end
end

include Mastermind

game = Game.new
