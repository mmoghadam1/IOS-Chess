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
            return true
    }
    
    
}
