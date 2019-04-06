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


}

