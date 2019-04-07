//
//  ViewController.swift
//  IOS_Chess
//
//  Created by rj morley on 4/4/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblDisplayTurn: UILabel!
    @IBOutlet var panOUTLET: UIPanGestureRecognizer!
    @IBOutlet weak var lblDisplayCheck: UILabel!
    var pieceDragged: UIChessPiece!
    var sourceOrigin: CGPoint!
    var destinationOrigin:CGPoint!
    static var space_from_left: Int = 15
    static var space_from_top: Int = 124
    static var tile_size: Int = 48
    var myChessGame:ChessGame!
    var chessPieces:[UIChessPiece]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        chessPieces=[]
        myChessGame = ChessGame.init(viewController:self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pieceDragged = touches.first!.view as? UIChessPiece
        if pieceDragged != nil{
            sourceOrigin = pieceDragged.frame.origin
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pieceDragged != nil{
            drag(piece: pieceDragged, usingGestureRecognizer: panOUTLET)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //align piece in square
        if pieceDragged != nil{
            let touchLocation = touches.first!.location(in: view)
            
            var x = Int(touchLocation.x)
            var y = Int(touchLocation.y)
            
            x -= ViewController.space_from_left
            x = (x/ViewController.tile_size)*ViewController.tile_size
            x += ViewController.space_from_left
            y -= ViewController.space_from_top
            y = (y/ViewController.tile_size)*ViewController.tile_size
            y += ViewController.space_from_top
        
            destinationOrigin = CGPoint(x:x,y:y)
            
            let sourceIndex = ChessBoard.indexOf(origin: sourceOrigin)
            let destinationIndex = ChessBoard.indexOf(origin: destinationOrigin)
            if myChessGame.isMoveValid(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destinationIndex){
                myChessGame.move(piece: pieceDragged, fromIndex:sourceIndex, toIndex:destinationIndex,toOrigin:destinationOrigin)
                myChessGame.nextTurn()
                updateTurn()
            }
            else{
                pieceDragged.frame.origin = sourceOrigin
            }
        }
    }
    func updateTurn(){
        lblDisplayTurn.text = myChessGame.isWhiteTurn ? "White's Turn" : "Black's Turn"
        lblDisplayTurn.textColor = myChessGame.isWhiteTurn ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1):#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func drag(piece:UIChessPiece, usingGestureRecognizer gestureRecognizer:
        UIPanGestureRecognizer){
        let translation = gestureRecognizer.translation(in: view)
        
        piece.center = CGPoint(x:translation.x+piece.center.x,y:translation.y+piece.center.y)
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
    }


}

