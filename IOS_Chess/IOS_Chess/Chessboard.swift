//
//  swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

class ChessBoard: NSObject {
    var board:[[Piece]]!
    var vc: ViewController!
    let rows = 8
    let cols = 8
    var whiteKing: King!
    var blackKing: King!
    
    
    func getIndex(forChessPiece chessPieceToFind: UIChessPiece) -> BoardIndex? {
        for row in 0..<rows{
            for col in 0..<cols{
                let aChessPiece = board[row][col] as? UIChessPiece
                if chessPieceToFind == aChessPiece{
                    return BoardIndex(row: row, col: col)
                }
            }
        }
        return nil
    }
    
    func rm(piece:Piece){
        if let chessPiece = piece as? UIChessPiece{
            //rm from matrix
            let indexOnBoard = ChessBoard.indexOf(origin: chessPiece.frame.origin)
            
            board[indexOnBoard.row][indexOnBoard.col]=Dummy(frame: chessPiece.frame)
            
            //rm from array of pieces
            if let arrayIndex = vc.chessPieces.index(of: chessPiece){
                vc.chessPieces.remove(at: arrayIndex)
            }
            
            //rm piece from screen
            chessPiece.removeFromSuperview()
        }
    }
    
    func place(chessPiece: UIChessPiece, toIndex destinationIndex: BoardIndex, toOrigin destinationOrigin:CGPoint){
        chessPiece.frame.origin = destinationOrigin
        board[destinationIndex.row][destinationIndex.col] = chessPiece
    }
    
    static func indexOf(origin:CGPoint) -> BoardIndex{
        let row = (Int(origin.y)-ViewController.space_from_top)/ViewController.tile_size
        let col = (Int(origin.x)-ViewController.space_from_left)/ViewController.tile_size

        return BoardIndex(row:row,col:col)
    }
    
    static func getFrame(forRow row:Int, forCol col: Int) ->CGRect{
        let x = CGFloat(ViewController.space_from_left+col*ViewController.tile_size)
        let y = CGFloat(ViewController.space_from_top+row*ViewController.tile_size)
        
        return CGRect(origin: CGPoint(x:x,y:y), size: CGSize(width: ViewController.tile_size, height: ViewController.tile_size))
    }
    
    init(viewController:ViewController){
        
        vc = viewController
        //init board w dummies
        let singleRow = Array(repeating: Dummy(), count: cols)
        board = Array(repeating: singleRow, count: rows)
        
        for row in 0..<rows{
            for col in 0..<cols{
                switch row{
                case 0:
                    switch col{
                    case 0:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 4:
                        blackKing = King(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                        board[row][col] = blackKing
                    case 5:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    default:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    }
                case 1:
                    board[row][col] = Pawn(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                case 6:
                    board[row][col] = Pawn(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                case 7:
                    switch col{
                    case 0:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 4:
                        whiteKing = King(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                        board[row][col] = whiteKing
                    case 5:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    default:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    }
                default:
                    board[row][col] = Dummy(frame: ChessBoard.getFrame(forRow: row, forCol: col))
                }
            }
        }
    }
}
