/* abstract square filling predicate for Noughts & Crosses practical */

:- module( fill, [fill_square/5] ).

fill_square( X, Y, Player, Board, NewBoard ) :-
	user:empty_board( NewBoard ),
	replace_in_rows( 3, X, Y, Player, Board, NewBoard ).

replace_in_rows( 0, _, _, _, _, _ ).
replace_in_rows( Row, X, Y, Player, Board, NewBoard ) :-
	Row > 0,
	replace_in_columns( 3, Row, X, Y, Player, Board, NewBoard ),
	NextRow is Row - 1,
	replace_in_rows( NextRow, X, Y, Player, Board, NewBoard ).

replace_in_columns( 0, _, _, _, _, _, _ ).
replace_in_columns( Column, Row, Column, Row, Player, Board, NewBoard ) :-
	Column > 0,
	user:square( Column, Row, NewBoard, squ( Column, Row, Player )),
	NextColumn is Column - 1,
	replace_in_columns( NextColumn, Row, Column, Row, Player,
							Board, NewBoard ).
replace_in_columns( Column, Row, X, Y, Player, Board, NewBoard ) :-
	Column > 0,
	\+ ( Column = X, Row = Y ),
	user:square( Column, Row, Board, squ( Column, Row, OldSquare )),
	user:square( Column, Row, NewBoard, squ( Column, Row, OldSquare )),
	NextColumn is Column - 1,
	replace_in_columns( NextColumn, Row, X, Y, Player, Board, NewBoard ).
