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
row( X, Board, row( X, A, B, C ) ) :-
    nth1( X, Board, [A, B, C]).

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
    square( X, Y, Board, squ( X, Y, Piece ) ),
    is_empty( Piece ).

% initial_board( ?Board )
% Succeeds when Board represents the initial state of the board
initial_board( [ [b, b, b], [b, b, b], [b, b, b] ] ).

% empty_board( ?Board )
% Succeeds when Board represents an uninstantiated board.
empty_board( [ [_, _, _], [_, _, _], [_, _, _] ] ).

/*              2. SPOTTING A WINNER                */ 

% and_the_winner_is( ?Board, ?Player )
% Succeeds if Player has won on Board
and_the_winner_is( Board, Player ) :- 
    is_piece( Player ),
    row( X, Board, row( X, Player, Player, Player ) ).

and_the_winner_is( Board, Player ) :-
    is_piece( Player ),
    column( X, Board, col( X, Player, Player, Player ) ).

and_the_winner_is( Board, Player ) :- 
    is_piece( Player ),
    diagonal( X, Board, dia( X, Player, Player, Player ) ).


/*     3. RUNNING A GAME FOR 2 HUMAN PLAYERS        */

% playHH/0
% Provided in specification of the project
% Begins a human-human game
playHH :-   
    welcome,
    initial_board( Board ),
    display_board( Board ),
    is_cross( Cross ),
    playHH( Cross, Board ).

% no_more_free_squares( ?Board )
% succeeds if Board has no more empty squares
no_more_free_squares( Board ) :-
    is_empty( Piece ),
    \+ square( X, Y, Board, squ(X, Y, Piece ) ).

% playHH( ?Player, ?Board)
% 3 possibilities:  report winner / report stalemate / 
%                   do move and play again
playHH( _Player, Board ) :-
    and_the_winner_is( Board, Player ),
    report_winner( Player ).

playHH( _Player, Board ) :-
    no_more_free_squares( Board ),
    report_stalemate.

playHH( Player, Board ) :-
    get_legal_move( Player, X, Y, Board ),
    report_move( Player, X, Y ),
    fill_square( X, Y, Player, Board, NewBoard ),
    display_board( NewBoard ),
    other_player( Player, Next ),
    playHH( Next, NewBoard).

/*  4. RUNNING A GAME FOR 1 HUMAN AND THE COMPUTER  */

% playHC/0
% begins a human-computer game
playHC :-
    welcome,
    initial_board( Board ),
    display_board( Board ),
    is_cross( Cross ),
    playHC( Cross, Board ).

% playHC( ?Player, ?Board )
% 4 possibilities: report winner / report stalemate /
%                   human move (x) / computer move (o)
playHC( _Player, Board ) :-
    no_more_free_squares( Board ),
    report_stalemate.

playHC(_Player, Board ) :-
    and_the_winner_is( Board, Player),
    report_winner( Player ).

playHC( Player, Board ) :-
    is_cross( Player ), % human move
    get_legal_move( Player, X, Y, Board ),
    report_move( Player, X, Y ),
    fill_square( X, Y, Player, Board, NewBoard ),
    display_board( NewBoard ),
    is_nought( Computer ),
    playHC( Computer, NewBoard).

playHC( Player, Board ) :-
    is_nought( Player ), % computer move
    choose_move( Player, X, Y, Board ),
    report_move( Player, X, Y ),
    fill_square( X, Y, Player, Board, NewBoard ),
    display_board( NewBoard ),
    is_cross( Human ),
    playHC( Human, NewBoard).

/*          5. IMPLEMENTING THE HEURISTICS          */

% choose_move( ?Player, ?X, ?Y, Board )
% succeeds when it can find a move for Player in position (X, Y)
% according to the heuristics defined in the specification of the project

% 1. if there is a winning line for self, then take it:
choose_move( Player, X, Y, Board ) :-
    winning_move( Player, Board, X, Y).

% 2. if there is a winning line for opponent, then block it:
choose_move( Player, X, Y, Board ) :-
    other_player( Player, Other ),
    winning_move( Other, Board, X, Y).

% 3. if the middle space is free, then take it:
choose_move( _Player, 2, 2, Board ) :-
    empty_square( 2, 2, Board ).

% 4. if there is a corner space free, then take it:
choose_move( _Player, X, Y, Board ) :-
    empty_square( X, Y, Board ),
    X \= 2,
    Y \= 2.

% 5. otherwise, dumbly choose the next space
choose_move( _Player, X, Y, Board ) :- empty_square( X, Y, Board).

% two_out_of_three( Player, ?X1, ?X2, ?X3, ?Pos )
% succeeds if two out of the three variables are the same as Player,
% pos is the index of the other variable and the other variable is an empty spot
two_out_of_three( Player, Player, Player, Blank, 3 ) :-
    is_empty( Blank ).

two_out_of_three( Player, Player, Blank, Player, 2 ):-
    is_empty( Blank ).

two_out_of_three( Player, Blank, Player, Player, 1 ):-
    is_empty( Blank ).

% winning_move( ?Player, ?Board, ?X, ?Y )
% succeeds if the player would win after placing his piece at X, Y
winning_move( Player, Board, X, Y ) :-
    row( Y, Board, row( Y, A, B, C ) ),
    two_out_of_three( Player, A, B, C, X ). 

winning_move( Player, Board, X, Y ) :-
    column( X, Board, col( X, A, B, C ) ),
    two_out_of_three( Player, A, B, C, Y ). 

winning_move( Player, Board, X, X ) :-
    diagonal( top_to_bottom, Board, dia( top_to_bottom, A, B, C ) ),
    two_out_of_three( Player, A, B, C, X ).

winning_move( Player, Board, X, Y ) :-
    diagonal( bottom_to_top, Board, dia( bottom_to_top, A, B, C ) ),
    two_out_of_three( Player, A, B, C, X ),
    Y is 4 - X.  

% playSS/0
% same as playHC/0 except that it detects a stalemate as soon as it happens
playSS :-
    welcome,
    initial_board( Board ),
    display_board( Board ),
    is_cross( Cross ),
    playSS( Cross, Board ).

% playSS( ?Player, ?Board )
% same as playHC/2 except that it detects a stalemate as soon as it happens
playSS( Player, Board ) :-
    \+ possible_win( Player, Board ),
    report_stalemate.

playSS(_Player, Board ) :-
    and_the_winner_is( Board, Player),
    report_winner( Player ).

playSS( Player, Board ) :-
    is_cross( Player ), % human move
    get_legal_move( Player, X, Y, Board ),
    report_move( Player, X, Y ),
    fill_square( X, Y, Player, Board, NewBoard ),
    display_board( NewBoard ),
    is_nought( Computer ),
    playSS( Computer, NewBoard).

playSS( Player, Board ) :-
    is_nought( Player ), % computer move
    choose_move( Player, X, Y, Board ),
    report_move( Player, X, Y ),
    fill_square( X, Y, Player, Board, NewBoard ),
    display_board( NewBoard ),
    is_cross( Human ),
    playSS( Human, NewBoard).

% possible_win( ?Player, ?Board )
% Succeeds if any player can win on the current Board
possible_win( Player, Board ) :-
    winning_move( Player, Board, _X, _Y ).

possible_win( Player, Board ) :-
    other_player( Player, Other ),
    winning_move( Other, Board, _X, _Y ).

possible_win( Player, Board ) :-
    empty_square( X, Y, Board ),
    fill_square( X, Y, Player, Board, NewBoard ),
    other_player( Player, Other ),
    possible_win( Other, NewBoard ).

/*         ***       TEST CASES       ***           */

% board representation
test_board_representation :-
    test_row,
    test_column,
    test_diagonal,
    test_square,
    test_empty_square.

test_row :-
    row( 1, [ [a,b,c], [d,e,f],[g,h,i] ], row( 1, a, b, c ) ),
    row( 2, [ [a,b,c], [d,e,f],[g,h,i] ], row( 2, d, e, f ) ),
    row( 3, [ [a,b,c], [d,e,f],[g,h,i] ], row( 3, g, h, i ) ).

test_column :-
    column( 1, [ [a,b,c], [d,e,f],[g,h,i] ], col( 1, a, d, g ) ),
    column( 2, [ [a,b,c], [d,e,f],[g,h,i] ], col( 2, b, e, h ) ),
    column( 3, [ [a,b,c], [d,e,f],[g,h,i] ], col( 3, c, f, i ) ).

test_diagonal :-
    diagonal( top_to_bottom, [ [a,b,c],[d,e,f],[g,h,i] ], dia( top_to_bottom, a, e, i ) ),
    diagonal( bottom_to_top, [ [a,b,c],[d,e,f],[g,h,i] ], dia( bottom_to_top, g, e, c ) ).

test_square :-
    square( 1, 1, [ [a,b,c], [d,e,f], [g,h,i] ], squ( 1, 1, a ) ),
    square( 2, 3, [ [a,b,c], [d,e,f], [g,h,i] ], squ( 2, 3, h ) ),
    square( 3, 3, [ [a,b,c], [d,e,f], [g,h,i] ], squ( 3, 3, i ) ).

test_empty_square :-
    empty_square( 2, 1, [ [a,b,c], [d,e,f], [g,h,i] ] ),
    \+ empty_square( 3, 2, [ [a,b,c], [d,e,f], [g,h,i] ] ).

test_no_free_squares :-
    no_more_free_squares( [ [a,x,c], [d,e,f],[ g,h,i] ] ),
    \+ no_more_free_squares( [ [a,b,c], [d,e,f], [g,h,i] ] ).

% winner recognition
test_winner :-
    and_the_winner_is( [ [x, x, x], [b, b, b], [b, b, b] ], x ),
    and_the_winner_is( [ [o, x, x], [b, o, b], [b, b, o] ], o ),
    and_the_winner_is( [ [x, x, o], [b, b, o], [b, o, o] ], o ).

% heuristics
test_two_out_of_three :-
    two_out_of_three( x, x, x, b, 3),
    two_out_of_three( x, x, b, x, 2),
    two_out_of_three( o, b, o, o, 1),
    \+ two_out_of_three( x, x, x, o, 3).

test_winning_move :-
    winning_move( x, [ [x, x, o], [b, x, x], [b, b, b] ], 1, 2 ),
    winning_move( x, [ [b, x, b], [b, b, b], [b, x, b] ], 2, 2 ),
    winning_move( x, [ [x, b, b], [b, x, b], [b, b, b] ], 3, 3 ),
    winning_move( x, [ [b, b, b], [b, x, b], [x, b, b] ], 3, 1 ).

test_choose_move :-
    choose_move( x, 3, 1, [ [x, x, b], [b, b, b], [b, b, b] ] ),
    choose_move( x, 2, 3, [ [x, o, b], [b, o, b], [b, b, b] ] ),
    choose_move( x, 2, 2, [ [x, o, b], [b, b, b], [b, b, b] ] ),
    choose_move( x, 3, 1, [ [x, b, b], [b, x, b], [o, x, o] ] ).

test_possible_win :-
    possible_win( x, [ [b, b, b], [b, b, b], [b, b, b] ] ),
    possible_win( x, [ [x, x, b], [b, b, b], [b, b, b] ] ),
    possible_win( x, [ [x, x, o], [o, b, b], [b, o, b] ] ),
    \+ possible_win( x, [ [x, b, o], [o, x, x], [x, o, o] ] ).
    

test_heuristics :-
    test_two_out_of_three,
    test_winning_move,
    test_choose_move,
    test_possible_win.

% all tests together
full_test_suite :-
    test_board_representation,
    test_winner,
    test_no_free_squares,
    test_heuristics.