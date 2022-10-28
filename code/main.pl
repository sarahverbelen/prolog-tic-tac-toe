/*  
    Project for Declarative Programming 
         Academic year 2022-2023
    Sarah Verbelen - Studentnr. 0588601
*/

:- use_module( [library(lists),
               io,
               fill] ).

/*             1. BOARD REPRESENTATION              */

%  is_SYMBOL( ?Element ) 
%  succeeds if Element is the SYMBOL character
is_cross(x).

is_nought(o).

is_empty(b).

%  is_piece( ?Element ) 
%  succeeds if Element is either the cross or the nought character
is_piece( Element ) :-
    is_cross( Element ).

is_piece( Element ) :-
    is_nought( Element ).

%  other_player( ?El1, ?El2 ) 
%  succeeds if El1 and El2 are different player representation characters (one cross and one nought)
other_player( El1, El2 ) :-
    is_cross( El1 ),
    is_nought( El2 ).

other_player( El1, El2 ) :-
    is_nought( El1 ),
    is_cross( El2 ).

% row( ?N, ?Board, ?Result )
% Succeeds when N is a row number (between 1 and 3) and Board is a representation of a board state
% Result will then be a term of the form row(N, A, B, C) where A, B, C are the values of the squares in that row
row( 1, [ [A, B, C], [_, _, _], [_, _, _] ], row( 1, A, B, C ) ).
row( 2, [ [_, _, _], [A, B, C], [_, _, _] ], row( 2, A, B, C ) ).
row( 3, [ [_, _, _], [_, _, _], [A, B, C] ], row( 3, A, B, C ) ).

% column( ?N, ?Board, ?Result )
% Succeeds when N is a column number (between 1 and 3) and Board is a representation of a board state
% Result will then be a term of the form col(N, A, B, C) where A, B, C are the values of the squares in that column
column( 1, [ [A, _, _], [B, _, _], [C, _, _] ], col( 1, A, B, C ) ).
column( 2, [ [_, A, _], [_, B, _], [_, C, _] ], col( 2, A, B, C ) ).
column( 3, [ [_, _, A], [_, _, B], [_, _, C] ], col( 3, A, B, C ) ).

% diagonal( ?Dir, ?Board, ?Result )
% Succeeds when Dir is either top_to_bottom or bottom_to_top and Board a representation of a board state
% Result will then be a term of the form dia(Dir, A, B, C) where A, B and C are the values of the squares in that diagonal
% top_to_bottom = top left to bottom right; bottom_to_top = bottom left to top right
diagonal( top_to_bottom, [ [A, _, _], [_, B, _], [_, _, C] ], dia( top_to_bottom, A, B, C ) ).
diagonal( bottom_to_top, [ [_, _, A], [_, B, _], [C, _, _] ], dia( bottom_to_top, C, B, A ) ).

% square( ?X, ?Y, ?Board, ?Result )
% succeeds when X and Y are numbers between 1 and 3 and Board is a representation of a board state
% Result will be a term of the form squ(X, Y, Piece) where Piece indicates what (if anything) is occupying the square at coordinates (X, Y)
square( X, 1, Board, squ(X, 1, Res) ) :-
    column( X, Board, col( X, Res, _, _ ) ).

square( X, 2, Board, squ(X, 2, Res) ) :-
    column( X, Board, col( X, _, Res, _ ) ).

square( X, 3, Board, squ(X, 3, Res) ) :-
    column( X, Board, col( X, _, _, Res ) ).

% empty_square( ?X, ?Y, ?Board )
% succeeds when X and Y are numbers between 1 and 3, Board is a representation of a board state
% and the relevant square is empty
empty_square( X, Y, Board ) :-
    square(X, Y, Board, squ(X, Y, Piece)),
    is_empty(Piece).

% initial_board( ?Board )
% Succeeds when Board represents the initial state of the board
initial_board( [ [b, b, b], [b, b, b], [b, b, b] ] ).

% empty_board( ?Board )
% Succeeds when Board represents an uninstantiated board.
empty_board( [ [_, _, _], [_, _, _], [_, _, _] ] ).

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
% (note to self: everything but the user input stuff)

% board representation

test_board_representation :-
    test_row,
    test_column,
    test_diagonal,
    test_square,
    test_empty_square.

test_row :-
    row(1, [[a,b,c],[d,e,f],[g,h,i]], row(1, a, b, c)),
    row(2, [[a,b,c],[d,e,f],[g,h,i]], row(2, d, e, f)),
    row(3, [[a,b,c],[d,e,f],[g,h,i]], row(3, g, h, i)).

test_column :-
    column(1, [[a,b,c],[d,e,f],[g,h,i]], col(1, a, d, g)),
    column(2, [[a,b,c],[d,e,f],[g,h,i]], col(2, b, e, h)),
    column(3, [[a,b,c],[d,e,f],[g,h,i]], col(3, c, f, i)).

test_diagonal :-
    diagonal(top_to_bottom, [[a,b,c],[d,e,f],[g,h,i]], dia(top_to_bottom, a, e, i)),
    diagonal(bottom_to_top, [[a,b,c],[d,e,f],[g,h,i]], dia(bottom_to_top, g, e, c)).

test_square :-
    square(1, 1, [[a,b,c],[d,e,f],[g,h,i]], squ(1, 1, a)),
    square(2, 3, [[a,b,c],[d,e,f],[g,h,i]], squ(2, 3, h)),
    square(3, 3, [[a,b,c],[d,e,f],[g,h,i]], squ(3, 3, i)).

test_empty_square :-
    empty_square(2, 1, [[a,b,c],[d,e,f],[g,h,i]]).