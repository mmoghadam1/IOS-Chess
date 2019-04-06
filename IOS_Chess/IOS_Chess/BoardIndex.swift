//
//  BoardIndex.swift
//  IOS_Chess
//
//  Created by Maxim Moghadam on 4/5/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

struct BoardIndex: Equatable{
    var row: Int
    var col: Int
    
    init(row:Int, col:Int){
        self.row = row
        self.col = col
    }
    
    static func == (lhs:BoardIndex,rhs:BoardIndex) -> Bool{
        return(lhs.row == rhs.row && lhs.col == rhs.col)
    }
}
