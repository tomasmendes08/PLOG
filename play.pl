start:-
    initial(GameState),
    display_game(GameState),
    gameLoop(GameState).

startPvsBot:-
    initial(GameState),
    display_game(GameState),
    gameLoopPvBotEasy(GameState).

startBotvsBot:-
    initial(GameState),
    display_game(GameState),
    gameLoopBotvBot(GameState).

initial(GameState):-
    initialBoard(GameState).
    %initialBoard(GameState).

display_game(GameState):-
    printBoard(GameState).

botMove(GameState, Move, Player, AfterWhiteMove):-
    nth0(0, Move, SelectCol),
    nth0(1, Move, SelectRow),
    nth0(2, Move, MoveCol),
    nth0(3, Move, MoveRow),
    movePiece(GameState, SelectCol, SelectRow, MoveCol, MoveRow, AfterWhiteMove),
    format('~w played [~w,~w] to [~w,~w]\n', [Player, SelectCol, SelectRow, MoveCol, MoveRow]).

wait:-
    write('Press enter to continue\n'),
    read_line(_).

gameLoopBotvBot(GameState):-
    Col is 0, 
    Row is 0,
    (
        (
        contentAnyFound(Col, Row, white, GameState),
        choose_move(GameState, white, 1, Move),
        botMove(GameState, Move, white, AfterWhiteMove),
        printBoard(AfterWhiteMove),
        iterationPrint(AfterWhiteMove),
        wait,
        NextGameState = AfterWhiteMove
        )
        ;
        (
        Check1 is 1,
        printBoard(GameState),
        iterationPrint(GameState),
        NextGameState = GameState
        )
    ),
    nl, %count players points 

    %black
    (
        (
        contentAnyFound(Col, Row, black, NextGameState),
        choose_move(NextGameState, black, 1, MoveBlack),
        botMove(NextGameState, MoveBlack, black, AfterBlackMove),
        printBoard(AfterBlackMove),
        iterationPrint(AfterBlackMove),
        wait,!,
        gameLoopBotvBot(AfterBlackMove)
        )
        ;
        (
        (
        \+checkGameOver(Check1),
        printBoard(NextGameState),
        iterationPrint(NextGameState),!,
        gameLoopBotvBot(NextGameState)
        )
        ;
        gameOver(GameState, Winner),
        congratulations(Winner)
        )

        
    ).

gameLoopPvBotEasy(GameState):-
    Col is 0, 
    Row is 0,
    (
        (
        contentAnyFound(Col, Row, white, GameState),
        choose_move(GameState, white, 1, Move),
        botMove(GameState, Move, white, AfterWhiteMove),
        printBoard(AfterWhiteMove),
        iterationPrint(AfterWhiteMove),
        wait,
        NextGameState = AfterWhiteMove
        )
        ;
        (
        Check1 is 1,
        printBoard(GameState),
        iterationPrint(GameState),
        NextGameState = GameState
        )
    ),
    nl, %count players points 

    %black
    (
        (
        contentAnyFound(Col, Row, black, NextGameState),
        choosePiece(NextGameState, AfterBlackMove, black),
        printBoard(AfterBlackMove),
        iterationPrint(AfterBlackMove),
        wait,!,
        gameLoopPvBotEasy(AfterBlackMove)
        )
        ;
        (
        (
        \+checkGameOver(Check1),
        printBoard(NextGameState),
        iterationPrint(NextGameState),!,
        gameLoopPvBotEasy(NextGameState)
        )
        ;
        gameOver(GameState, Winner),
        congratulations(Winner)
        )

        
    ).


gameLoopPvBotHard(GameState):-
    Col is 0, 
    Row is 0,
    (
        (
        contentAnyFound(Col, Row, white, GameState),
        choose_move(GameState, white, 2, Move),
        botMove(NextGameState, Move, white, AfterBlackMove),
        printBoard(AfterWhiteMove),
        iterationPrint(AfterWhiteMove),
        wait,
        NextGameState = AfterWhiteMove
        )
        ;
        (
        Check1 is 1,
        printBoard(GameState),
        iterationPrint(GameState),
        NextGameState = GameState
        )
    ),
    nl, %count players points 

    %black
    (
        (
        contentAnyFound(Col, Row, black, NextGameState),
        choosePiece(NextGameState, AfterBlackMove, black),
        printBoard(AfterBlackMove),
        iterationPrint(AfterBlackMove),
        wait,!,
        gameLoopPvBotHard(AfterBlackMove)
        )
        ;
        (
        (
        \+checkGameOver(Check1),
        printBoard(NextGameState),
        iterationPrint(NextGameState),!,
        gameLoopPvBotHard(NextGameState)
        )
        ;
        gameOver(GameState, Winner),
        congratulations(Winner)
        )

        
    ).


gameLoop(GameState):-
    Col is 0, 
    Row is 0,
    (
        (
        contentAnyFound(Col, Row, white, GameState),
        choosePiece(GameState, AfterWhiteMove, white),
        printBoard(AfterWhiteMove),
        iterationPrint(AfterWhiteMove),
        NextGameState = AfterWhiteMove
        )
        ;
        (
        Check1 is 1,
        printBoard(GameState),
        iterationPrint(GameState),
        NextGameState = GameState
        )
    ),
    nl, %count players points 

    %black
    (
        (
        contentAnyFound(Col, Row, black, NextGameState),
        choosePiece(NextGameState, AfterBlackMove, black),
        printBoard(AfterBlackMove),
        iterationPrint(AfterBlackMove),!,
        gameLoop(AfterBlackMove)
        )
        ;
        (
        (
        \+checkGameOver(Check1),
        printBoard(NextGameState),
        iterationPrint(NextGameState),!,
        gameLoop(NextGameState)
        )
        ;
        gameOver(GameState, Winner),
        congratulations(Winner)
        )

        
    ).


gameOver(GameState, Winner):-
    value(GameState, white, ValueW),
    value(GameState, black, ValueB),
    (
    ValueW > ValueB,
    Winner = 'White'
    ;
    ValueW < ValueB,
    Winner = 'Black'
    ;
    Winner = 'Tie'
    ).


congratulations(Winner):-
    (Winner == 'White' ; Winner == 'Black'),
    write('GAME OVER!\n'),
    format('Winner is ~w!', Winner).


congratulations(Winner):-
    Winner == 'Tie',
    write('The game is a tie!\n').