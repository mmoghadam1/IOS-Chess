//
//  Queen.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

class Queen:UIChessPiece{
    init(frame:CGRect, color:UIColor, vc:ViewController){
        super.init(frame   : frame)
        
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
            self.text = "♛"
        }
        else{
            self.text = "♕"
        }
        self.isOpaque = false
        self.textColor = color
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.font = self.font.withSize(36)
        
        vc.chessPieces.append(self)
        vc.view.addSubview(self)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
