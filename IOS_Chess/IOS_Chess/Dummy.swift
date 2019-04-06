//
//  Dummy.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import Foundation
import UIKit

class Dummy: Piece{
    private var xStore: CGFloat!
    private var yStore: CGFloat!
    var x: CGFloat{
        get{
            return self.xStore
        }
        set{
            self.xStore = newValue
        }
    }
    var y: CGFloat{
        get{
            return self.yStore
        }
        set{
            self.yStore = newValue
        }
    }
    init(frame:CGRect){
        self.xStore = frame.origin.x
        self.yStore = frame.origin.y
    }
    init(){
        
    }
}
