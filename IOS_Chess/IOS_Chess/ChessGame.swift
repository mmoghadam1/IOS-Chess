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
    init(viewController: ViewController){
        bboard = ChessBoard.init(viewController:viewController)
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
            break
        default:
            break
        }
        return true
    }

    func IsMoveValid(forPawn: Pawn, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool{
        return true
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


    func isMoveValid(forKing: King, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool{
        return true
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
