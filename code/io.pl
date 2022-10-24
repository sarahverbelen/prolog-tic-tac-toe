/* IO module for Noughts & Crosses practical */

:- module( io, [display_board/1, report_move/3, welcome/0,
		get_legal_move/4, report_winner/1, report_stalemate/0] ).

display_board( Board ) :-
	format( '\n  123\n +---+\n', [] ),
	display_rows( 1, Board ),
	format( ' +---+\n\n', [] ).

display_rows( 4, _Board ).
display_rows( RowNumber, Board ) :-
	RowNumber > 0, RowNumber < 4,
	user:row( RowNumber, Board, Row ), 
	display_row( Row ),
	NextRowNumber is RowNumber + 1,
	display_rows( NextRowNumber, Board ).

display_row( row( N, A, B, C ) ) :-
	format( '~w|~w~w~w|\n', [N,A,B,C] ).

report_move( Player, X, Y ) :-
	format( 'Player ~w takes square at (~w,~w).\n', [Player,X,Y] ).

report_blocked :-
	format( '\nThat space is taken. Please try again.\n', [] ).

request_move( Player, Which, Answer ) :-
	format( 'Player ~w, please input ~w number: ', [Player,Which] ),
	ttyflush,
	read( Answer ),
	Answer > 0,
	Answer < 4,
	!.
request_move( Player, Which, Answer ) :-
	format( 'Please enter a number between 1 and 3.\n', [] ),
	request_move( Player, Which, Answer ).

report_winner( Winner ) :-
	format( 'Player ~w is the winner!\n', [Winner] ).

get_legal_move( Player, X, Y, Board ) :-
	request_move( Player, column, X ),
	request_move( Player, row, Y ),
	user:empty_square( X, Y, Board ),
	!.
get_legal_move( Player, X, Y, Board ) :-
	report_blocked,
	get_legal_move( Player, X, Y, Board ).

report_stalemate :-
	format( 'Stalemate. The game is drawn.\n', [] ).

welcome :-
	format( '\nWelcome to Noughts and Crosses!\n', [] ).
