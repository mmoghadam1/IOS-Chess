//
//  ChessGame.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

class ChessGame: NSObject{
    var bboard:ChessBoard!
    var isWhiteTurn = true
    var winner: String?
    var wins = Int()
    
    init(viewController: ViewController){
        super.init()
        bboard = ChessBoard.init(viewController:viewController)
    }
    
    func getArrayOfPossibleMoves(forPiece piece: UIChessPiece) -> [BoardIndex]{
        
        var arrayOfMoves: [BoardIndex] = []
        let source = bboard.getIndex(forChessPiece: piece)!
        
        for row in 0..<bboard.rows{
            for col in 0..<bboard.cols{
                
                let dest = BoardIndex(row: row, col: col)
                
                if isRegularMoveValid(forPiece: piece, fromIndex: source, toIndex: dest){
                    arrayOfMoves.append(dest)
                }
            }
        }
        
        return arrayOfMoves
    }
    
    func AIMove(){
        //get white king if possible
        if getPlayerChecked() == "White" {
            for chessPiece in bboard.vc.chessPieces{
                if chessPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
                    guard let source = bboard.getIndex(forChessPiece: chessPiece) else{
                        continue
                    }
                    guard let dest = bboard.getIndex(forChessPiece: bboard.whiteKing) else{
                        continue
                    }
                    if isRegularMoveValid(forPiece: chessPiece, fromIndex: source, toIndex: dest){
                        move(piece: chessPiece, fromIndex: source, toIndex: dest, toOrigin: bboard.whiteKing.frame.origin)
                        print("AI - attacking white king")
                        return
                    }
                }
            }
        }
        //attack undefended piece
        if getPlayerChecked() == nil{
            if attackedPiece(){
                print("AI attacked undefended piece")
                return
            }
        }
        var hasMove = false
        var escapesFromCheck = 0
        searchForMoves: while hasMove == false {
            //get random piece
            let randPieceIndex = Int(arc4random_uniform(UInt32(bboard.vc.chessPieces.count)))
            let pieceToMove = bboard.vc.chessPieces[randPieceIndex]
            guard pieceToMove.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) else{
                continue searchForMoves
            }
            //get random move
            let arrayOfMoves = getArrayOfPossibleMoves(forPiece: pieceToMove)
            guard arrayOfMoves.isEmpty == false else{
                continue searchForMoves
            }
            let randomMoves = Int(arc4random_uniform(UInt32(arrayOfMoves.count)))
            let randomDestination = arrayOfMoves[randomMoves]
            let destOrigin = ChessBoard.getFrame(forRow: randomDestination.row, forCol: randomDestination.col).origin
            guard let sourceIndex = bboard.getIndex(forChessPiece: pieceToMove) else{
                continue searchForMoves
            }
            //simulate ai movement
            let takenPiece = bboard.board[randomDestination.row][randomDestination.col]
            bboard.board[randomDestination.row][randomDestination.col] = bboard.board[sourceIndex.row][sourceIndex.col]
            bboard.board[sourceIndex.row][sourceIndex.col] = Dummy()
            
            if escapesFromCheck < 10000{
                guard getPlayerChecked() != "Black" else{
                    //undo move
                    bboard.board[sourceIndex.row][sourceIndex.col] = bboard.board[randomDestination.row][randomDestination.col]
                    bboard.board[randomDestination.row][randomDestination.col] = takenPiece
                    escapesFromCheck+=1
                    continue searchForMoves
                }
            }
            
            //undo move
            bboard.board[sourceIndex.row][sourceIndex.col] = bboard.board[randomDestination.row][randomDestination.col]
            bboard.board[randomDestination.row][randomDestination.col] = takenPiece
            
            if isbestAIMove(forScoreOver: 2){
                print("AI made its best move")
                return
            }
            if escapesFromCheck == 0 || escapesFromCheck == 0{
                print("AI made simple random move")
            }
            else{
                print("AI made a random move to escape check")
            }
            move(piece: pieceToMove, fromIndex: sourceIndex, toIndex: randomDestination, toOrigin: destOrigin)
            hasMove = true
        }
    }

    func isbestAIMove(forScoreOver limit: Int) ->Bool{
        guard getPlayerChecked() != "Black" else{
            return false
        }
        var bestScore = -1
        var bestPiece: UIChessPiece!
        var bestDest: BoardIndex!
        var bestSource: BoardIndex!
        var bestOrigin: CGPoint!
        
        for piece in bboard.vc.chessPieces{
            guard piece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) else{
                continue
            }
            guard let source = bboard.getIndex(forChessPiece: piece) else{
                continue
            }
            let actualScore = getScore(ofPiece: piece)
            let possibleMoves = getArrayOfPossibleMoves(forPiece: piece)
            for move in possibleMoves{
                var nextScore = -1
                let takenPiece = bboard.board[move.row][move.col]
                bboard.board[move.row][move.col] = bboard.board[source.row][source.col]
                bboard.board[source.row][source.col] = Dummy()
                
                nextScore = getScore(ofPiece: piece)
                let score = nextScore-actualScore
                
                if score > bestScore{
                    bestScore = score
                    bestPiece = piece
                    bestDest = move
                    bestSource = source
                    bestOrigin = ChessBoard.getFrame(forRow: bestDest.row, forCol: bestDest.col).origin
                }
                
                //undo move
                bboard.board[source.row][source.col] = bboard.board[move.row][move.col]
                bboard.board[move.row][move.col]=takenPiece
            }
        }
        
        if bestScore>limit{
            move(piece: bestPiece, fromIndex: bestSource, toIndex: bestDest, toOrigin: bestOrigin)
            print("AI - Best score: \(bestScore)" )
            return true
        }
        
        return false
    }
    func attackedPiece() -> Bool{
        loopPieces: for attackingPiece in bboard.vc.chessPieces{
            guard attackingPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) else{
                continue
            }
            guard let src = bboard.getIndex(forChessPiece: attackingPiece) else{
                continue loopPieces
            }
            let possibleMoves = getArrayOfPossibleMoves(forPiece: attackingPiece)
            
            searchForAttack: for attackIndex in possibleMoves{
                guard let attackedPiece = bboard.board[attackIndex.row][attackIndex.col] as? UIChessPiece else{
                    continue searchForAttack
                }
                for row in 0..<bboard.rows{
                    for col in 0..<bboard.cols{
                        guard let defendingPiece = bboard.board[row][col] as? UIChessPiece, defendingPiece.color == #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) else{
                            continue
                        }
                        let defendIndex = BoardIndex(row:row,col:col)
                        if isRegularMoveValid(forPiece: defendingPiece, fromIndex: defendIndex, toIndex: attackIndex,alliedAttack: true){
                            continue searchForAttack
                        }
                    }
                }
                move(piece: attackingPiece, fromIndex: src, toIndex: attackIndex, toOrigin: attackedPiece.frame.origin)
                return true
            }
        }
        return false
    }
    
    
    func getScore(ofPiece aChessPiece: UIChessPiece) -> Int{
        var locationScore = 0
        guard let source = bboard.getIndex(forChessPiece: aChessPiece) else {
            return 0
        }
        for row in 0..<bboard.rows{
            for col in 0..<bboard.cols{
                if bboard.board[row][col] is UIChessPiece{
                    let dest = BoardIndex(row: row, col: col)
                    
                    if isRegularMoveValid(forPiece: aChessPiece, fromIndex: source, toIndex: dest, alliedAttack: true){
                        locationScore += 1
                    }
                }
            }
        }
        return locationScore
    }
    
    
    // when a pawn reaches the other side of the board it is changed into a queen
    func getPawnForPromotion() -> Pawn?{
        for chessPiece in bboard.vc.chessPieces{
            if let pawn = chessPiece as? Pawn{
                let pawnIndex = ChessBoard.indexOf(origin: pawn.frame.origin)
                if pawnIndex.row == 0 || pawnIndex.row == 7{
                    return pawn
                }
            }
        }
        return nil
    }
    
    //checks for when a king is in check
    func getPlayerChecked() -> String?{
        guard let whiteKingIndex = bboard.getIndex(forChessPiece: bboard.whiteKing)
            else{
            return nil
        }
        guard let blackKingIndex = bboard.getIndex(forChessPiece: bboard.blackKing)
        else{
                return nil
        }
        
        for row in 0..<bboard.rows{
            for col in 0..<bboard.cols{
                if let chessPiece = bboard.board[row][col] as? UIChessPiece{
                    
                    let chessPieceIndex = BoardIndex(row: row, col: col)
                    
                    if chessPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
                        if isRegularMoveValid(forPiece: chessPiece, fromIndex: chessPieceIndex, toIndex: whiteKingIndex){
                            return "White"
                        }
                    }
                    else{
                        if isRegularMoveValid(forPiece: chessPiece, fromIndex: chessPieceIndex, toIndex: blackKingIndex){
                            return "Black"
                        }
                    }
                }
            }
        }
        return nil
        
    }
    //checks for if someone has won then returns true or false
    func isGameOver() -> Bool{
        if didSomeOneWin(){
            return true
        }
        return false
    }
    
    //checks if someone has won the game
    func didSomeOneWin() -> Bool{
        
        if !bboard.vc.chessPieces.contains(bboard.whiteKing){
            winner = "Black"
            return true
        }
        
        if !bboard.vc.chessPieces.contains(bboard.blackKing){
            winner = "White"
            incrementWins()
            return true
        }
        return false
        
    }
    
    
    func move(piece chessPieceToMove: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint){
        
        //get initial chess piece frame
        let initialChessPieceFrame = chessPieceToMove.frame
        
        //remove piece at destination
        let pieceToRemove = bboard.board[destIndex.row][destIndex.col]
        bboard.rm(piece: pieceToRemove)
        
        //place the chess piece at destination
        bboard.place(chessPiece: chessPieceToMove, toIndex: destIndex, toOrigin: destOrigin)
        
        //put a Dummy piece in the vacant source tile
        bboard.board[sourceIndex.row][sourceIndex.col] = Dummy(frame: initialChessPieceFrame)
    }
    
    //checks to make sure the move a player makes is allowed
    func isMoveValid(piece:UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destinationIndex:BoardIndex)->Bool{
        // makes sure that the move corresponds to locations on the board
        guard isMoveOnBoard(forPieceFrom: sourceIndex, goesTo: destinationIndex) else{
            print("invalid move")
            return false
        }
        guard isTurn(sameAsPiece: piece) else{
            print("Wrong turn")
            return false
        }
        return isRegularMoveValid(forPiece: piece, fromIndex: sourceIndex, toIndex: destinationIndex)
    }
    func isRegularMoveValid(forPiece piece:UIChessPiece, fromIndex source: BoardIndex, toIndex destination: BoardIndex, alliedAttack: Bool = false) -> Bool {
        guard source != destination else{
            print("Moving piece to same position")
            return false
        }
        if !alliedAttack{
            guard !attackingPiece(sourcePiece: piece, destinationIndex: destination) else {
                print("attacking wrongpiece")
                return false
            }
        }
        switch piece {
            // checks for if each piece can make the move it was used for by calling its class function is move valid
        case is Pawn:
            return IsMoveValid(forPawn: piece as! Pawn, fromIndex: source, toIndex:destination)
        case is Rook, is Bishop, is Queen:
            return isMoveValid(forRookOrBishopOrQueen: piece , fromIndex: source, toIndex:destination)
        case is King:
            return isMoveValid(forKing: piece as! King, fromIndex: source, toIndex:destination)
        case is Knight:
            if !(piece as! Knight).doesFunctionSeemFine(fromIndex: source, toIndex: destination){
                return false
            }
        default:
            break
        }
        return true
    }

    func IsMoveValid(forPawn pawn: Pawn, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool{
        
        if !pawn.doesMoveSeemFine(fromIndex: source, toIndex: dest){
            return false
        }
        
        // conditions for not attacking a piece
        if source.col == dest.col{
            if pawn.triesToAdvanceBy2{
                var moveForward = 0
                
                if pawn.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
                    moveForward = 1
                }
                else{
                    moveForward = -1
                }
                
                if bboard.board[dest.row][dest.col] is Dummy && bboard.board[dest.row - moveForward][dest.col] is Dummy{
                    return true
                }
            }
            else{
                if bboard.board[dest.row][dest.col] is Dummy {
                    return true
                }
            }
        }
        
        else{
            if !(bboard.board[dest.row][dest.col] is Dummy){
                return true
            }
        }
        
        return false
    }
    
    func isMoveValid(forRookOrBishopOrQueen piece: UIChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        switch piece {
        case is Rook:
            if !(piece as! Rook).doesMoveSeemFine(fromIndex: source, toIndex: dest){
                return false
            }
        case is Bishop:
            if !(piece as! Bishop).doesMoveSeemFine(fromIndex: source, toIndex: dest){
                return false
            }
        case is Queen:
            if !(piece as! Queen).doesMoveSeemfine(fromIndex: source, toIndex: dest){
                return false
            }
        default:
            if !(piece as! Queen).doesMoveSeemfine(fromIndex: source, toIndex: dest){
                return false
            }
        }
        
        var increaseRow = 0
        
        if dest.row - source.row != 0 {
            increaseRow = (dest.row - source.row) / abs(dest.row - source.row)
        }
        
        var increaseCol = 0
        
        if dest.col - source.col != 0{
            increaseCol = (dest.col - source.col) / abs(dest.col - source.col)
        }

        var nextRow = source.row + increaseRow
        var nextCol = source.col + increaseCol
        
        while nextRow != dest.row || nextCol != dest.col{
            if !(bboard.board[nextRow][nextCol] is Dummy){
                return false
            }
            
            nextRow += increaseRow
            nextCol += increaseCol
        }
        
        return true
        
    }


    func isMoveValid(forKing king: King, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool{
        
        if !king.doesMoveSeemFine(fromIndex: source, toIndex: dest){
            return false
        }
        
        if isOpponentKing(nearKing: king, thatGoesTo: dest){
            return false
        }
        
        
        return true
    }
    
    func isOpponentKing(nearKing movingKing: King, thatGoesTo destIndexOfMovingKing: BoardIndex) -> Bool {
        
        var theOpponentKing: King
        
        if movingKing == bboard.whiteKing{
            theOpponentKing = bboard.blackKing
        }
        else{
            theOpponentKing = bboard.whiteKing
        }
        
        
        var indexOfOpponentKing: BoardIndex!
        
        for row in 0..<bboard.rows{
            for col in 0..<bboard.cols{
                if let aKing = bboard.board[row][col] as? King, aKing == theOpponentKing{
                    indexOfOpponentKing = BoardIndex(row: row, col: col)
                }
            }
        }
        
        let differenceInRows = abs(indexOfOpponentKing.row - destIndexOfMovingKing.row)
        let differenceInCols = abs(indexOfOpponentKing.col - destIndexOfMovingKing.col)
        
        // if the move is invalid
        if case 0...1 = differenceInRows{
            if case 0...1 = differenceInCols{
                return true
            }
        }
        return false
    }
    
    //tells if a piece is attempting to take another piece  and then removes the taken piece
    func attackingPiece(sourcePiece: UIChessPiece, destinationIndex: BoardIndex) -> Bool {
        
        let dest:Piece = bboard.board[destinationIndex.row][destinationIndex.col]
        guard !(dest is Dummy) else{
            return false
        }
        let chessDest = dest as! UIChessPiece
        return (sourcePiece.color == chessDest.color)
        
    }
    func nextTurn(){
        isWhiteTurn = !isWhiteTurn
    }
    func isTurn(sameAsPiece piece: UIChessPiece) -> Bool{
        if piece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
            if !isWhiteTurn{
                return true
            }
        }
        else{
            if isWhiteTurn{
                return true
            }
        }
        return false
    }
    
    func isMoveOnBoard(forPieceFrom sourceIndex: BoardIndex, goesTo destinationIndex: BoardIndex) -> Bool{
        if case 0..<bboard.rows = sourceIndex.row{
            if case 0..<bboard.cols = sourceIndex.col{
                if case 0..<bboard.rows = destinationIndex.row{
                    if case 0..<bboard.cols = destinationIndex.col{
                        return true
                    }
                }
            }
        }
        return false
    }
    // called when the user wins from increment wins returns the users prior number of wins
    func getUserWins() -> Int{
        
        let user = Auth.auth().currentUser?.uid
        wins = Database.database().reference().child("users").child(user!).value(forKey: "wins") as! Int
        return wins
        
    }
    
    //takes the users prior number of wins and increments by 1 then pushes the new number of wins to the database
    func incrementWins(){
        
        var tmpWins = getUserWins()
        tmpWins += 1
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let user = (Auth.auth().currentUser?.uid)!
        Database.database().reference().child("users").child(user).setValue(tmpWins, forKey: "wins")
        
    }
    
}
