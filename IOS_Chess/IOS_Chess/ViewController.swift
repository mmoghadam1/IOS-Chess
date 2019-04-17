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
    var playWithAI: Bool! = true
    
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
                resumeGame()
            }
            else{
                pieceDragged.frame.origin = sourceOrigin
            }
            
        }
        
    }
    func resumeGame(){
        //display checks, if any
        displayCheck()
        
        //change the turn
        myChessGame.nextTurn()
        
        //display turn on screen
        updateTurn()
        
        //make AI move, if necessary
        if playWithAI == true{ // &&}!myChessGame.isWhiteTurn{
            
            myChessGame.AIMove()
            print("AI: ---------------")
            
            if myChessGame.isGameOver(){
                displayWinner()
                return
            }
            
            
            if shouldPromotePawn(){
                promote(pawn: myChessGame!.getPawnForPromotion()!, into: "Queen")
            }
            
            displayCheck()
            
            myChessGame.nextTurn()
            
            updateTurn()
        }
    }
    func displayCheck(){
        let playerChecked = myChessGame.getPlayerChecked()
        
        if playerChecked != nil{
            lblDisplayCheck.text = playerChecked! + " is in check!"
        }
        else{
            lblDisplayCheck.text = nil
        }
    }
    
    
    func displayWinner(){
        let alert = UIAlertController(title: "Game over", message: "\(myChessGame.winner!) wins!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Back to menu", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "GameToMain", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Rematch", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
            for chessPiece in self.chessPieces{
                self.myChessGame.bboard.rm(piece: chessPiece)
            }
            
            self.myChessGame = ChessGame(viewController: self)
            
            self.updateTurn()
            self.lblDisplayCheck.text = nil
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func promote(pawn pawnToBePromoted: Pawn, into pieceName: String){
        let color = pawnToBePromoted.color
        let frame = pawnToBePromoted.frame
        let pawnIndex = ChessBoard.indexOf(origin: pawnToBePromoted.frame.origin)
        
        myChessGame.bboard.rm(piece: pawnToBePromoted)
        
        switch pieceName {
        case "Queen":
            myChessGame.bboard.board[pawnIndex.row][pawnIndex.col] = Queen(frame: frame, color: color, vc: self)
            
        case "Bishop":
            myChessGame.bboard.board[pawnIndex.row][pawnIndex.col] = Bishop(frame: frame, color: color, vc: self)
            
        case "Knight":
            myChessGame.bboard.board[pawnIndex.row][pawnIndex.col] = Knight(frame: frame, color: color, vc: self)
            
        case "Rook":
            myChessGame.bboard.board[pawnIndex.row][pawnIndex.col] = Rook(frame: frame, color: color, vc: self)
        default:
            break
        }
        
    }
    
    func promptForPawnPromotion(){
        if let pawnToPromote = myChessGame.getPawnForPromotion(){
            
            let box = UIAlertController(title: "Pawn promotion", message: "Choose piece", preferredStyle: UIAlertController.Style.alert)
            
            box.addAction(UIAlertAction(title: "Queen", style: UIAlertAction.Style.default, handler: {
                action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            box.addAction(UIAlertAction(title: "Bishop", style: UIAlertAction.Style.default, handler: {
                action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            box.addAction(UIAlertAction(title: "Knight", style: UIAlertAction.Style.default, handler: {
                action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            box.addAction(UIAlertAction(title: "Rook", style: UIAlertAction.Style.default, handler: {
                action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            self.present(box, animated: true, completion: nil)
        }
    }
    
    func shouldPromotePawn() -> Bool {
        return (myChessGame.getPawnForPromotion() != nil)
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

