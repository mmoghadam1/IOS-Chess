//
//  ExtensionUIChessPiece.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit
typealias UIChessPiece = UILabel

extension UIChessPiece: Piece{
    var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    
    var color: UIColor{
        get{
            return self.textColor
        }
    }
}
