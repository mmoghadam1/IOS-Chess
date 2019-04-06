//
//  ChessGame.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

class ChessGame: NSObject{
    var board:ChessBoard!
    init(viewController: ViewController){
        board = ChessBoard.init(viewController:viewController)
    }
}
