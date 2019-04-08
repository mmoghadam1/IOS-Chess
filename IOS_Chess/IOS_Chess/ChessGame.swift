//
//  ChessGame.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

class ChessGame: NSObject{
    var bboard:ChessBoard!
    var isWhiteTurn = true
    var winner: String?
    
    init(viewController: ViewController){
        bboard = ChessBoard.init(viewController:viewController)
    }
    
    
    
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
    
    func isGameOver() -> Bool{
        if didSomeOneWin(){
            return true
        }
        return false
    }
    
    func didSomeOneWin() -> Bool{
        
        if !bboard.vc.chessPieces.contains(bboard.whiteKing){
            winner = "Black"
            return true
        }
        
        if !bboard.vc.chessPieces.contains(bboard.blackKing){
            winner = "White"
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
    
    func isMoveValid(piece:UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destinationIndex:BoardIndex)->Bool{
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
    func isRegularMoveValid(forPiece piece:UIChessPiece, fromIndex source: BoardIndex, toIndex destination: BoardIndex) -> Bool {
        guard source != destination else{
            print("Moving piece to same position")
            return false
        }
        guard !attackingPiece(sourcePiece: piece, destinationIndex: destination) else {
            print("attacking wrongpiece")
            return false
        }
        switch piece {
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
            increaseRow = (dest.col - source.col) / abs(dest.col - source.col)
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
    
}
