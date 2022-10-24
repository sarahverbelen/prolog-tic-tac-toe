/*  
    Project for Declarative Programming 
         Academic year 2022-2023
    Sarah Verbelen - Studentnr. 0588601
*/

:- use_module( [library(lists),
               io,
               fill] ).

/*             1. BOARD REPRESENTATION              */

%  is_cross( ?Element ) 
%  succeeds if Element is the cross character
is_cross( Element ).

%  is_nought( ?Element ) 
%  succeeds if Element is the nought character
is_nought( Element ).

%  is_empty( ?Element ) 
%  succeeds if Element is the empty square character
is_empty( Element ).

%  is_piece( ?Element ) 
%  succeeds if Element is either the cross or the nought character
is_piece( Element ).

%  other_player( ?El1, ?El2 ) 
%  succeeds if El1 and El2 are different player representation characters (one cross and one nought)
is_cross( El1, El2 ).

% row( ?N, ?Board, ?Result )
% Succeeds when N is a row number (between 1 and 3) and Board is a representation of a board state
% Result will then be a term of the form row(N, A, B, C) where A, B, C are the values of the squares in that row
row( N, Board, Result ).

% column( ?N, ?Board, ?Result )
% Succeeds when N is a column number (between 1 and 3) and Board is a representation of a board state
% Result will then be a term of the form col(N, A, B, C) where A, B, C are the values of the squares in that column
column( N, Board, Result ).

% diagonal( ?Dir, ?Board, ?Result )
% Succeeds when Dir is either top_to_bottom or bottom_to_top and Board a representation of a board state
% Result will then be a term of the form dia(Dir, A, B, C) where A, B and C are the values of the squares in that diagonal
% top_to_bottom = top left to bottom right; bottom_to_top = bottom left to top right
diagonal( ?D, ?Board, ?Result )

% square( ?X, ?Y, ?Board, ?Result )
% succeeds when X and Y are numbers between 1 and 3 and Board is a representation of a board state
% Result will be a term of the form squ(X, Y, Piece) where Piece indicates what (if anything) is occupying the square at coordinates (X, Y)
square( X, Y, Board, Result ).

% empty_square( ?X, ?Y, ?Board )
% succeeds when X and Y are numbers between 1 and 3, Board is a representation of a board state
% and the relevant square is empty
empty_square( X, Y, Board ).

% initial_board( ?Board )
% Succeeds when Board represents the initial state of the board
initial_board( Board ).

% empty_board( ?Board )
% Succeeds when Board represents an uninstantiated board.
empty_board( Board ).

/*              2. SPOTTING A WINNER                */

% and_the_winner_is( ?Board, ?Player )
% Succeeds if Player has won on Board
and_the_winner_is( Board, Player ).

/*     3. RUNNING A GAME FOR 2 HUMAN PLAYERS        */

% playHH/0
% Provided in specification of the project
% Begins a human-human game
playHH :-   welcome,
            initial_board( Board ),
            display_board( Board ),
            is_cross( Cross ),
            playHH( Cross, Board ).

% no_more_free_squares( ?Board )
% succeeds if Board has no more empty squares
no_more_free_squares( Board ).

% playHH( ?Player, ?Board)
% 3 possibilities:  report winner / report stalemate / 
%                   do move and play again
playHH( Player, Board ).

% TODO at this point: create tests!

/*  4. RUNNING A GAME FOR 1 HUMAN AND THE COMPUTER  */

% playHC/0
% begins a human-computer game
playHC.

% playHC( ?Player, ?Board)
% 4 possibilieites: report winner / report stalemate /
%                   human move (x) / computer move (o)
playHC ( Player, Board ).

/*          5. IMPLEMENTING THE HEURISTICS          */

% choose_move( ?Player, ?X, ?Y, Board )
% succeeds when it can find a move for Player in position (X, Y)
% according to the heuristics defined in the specification of the project
choose_move(Player, X, Y, Board).

% dumbly choose the next space
choose_move( _Player, X, Y, Board ) :- empty_square( X, Y, Board).

% playSS/0
% same as playHC/0 except that it detects a stalemate as soon as it happens
playSS.

% playSS( ?Player, ?Board )
% same as playHC/2 except that it detects a stalemate as soon as it happens
playSS( Player, Board ).

% possible_win( ?Player, ?Board )
% Succeeds if any player can win from the current Board when it's currently Players turn
possible_win( Player, Board ).

/*         ***       TEST CASES       ***           */