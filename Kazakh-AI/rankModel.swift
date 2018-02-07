//
//  rankModel.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 03/08/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
class rankModel{
    private var _isAndroid: Bool?
    private var _isThisOne: Bool?
    private var _name: String?
    private var _rank: String?
    private var _score: String?
    
    var isAndroid: Bool{
        if let isAndroid = _isAndroid{
            return isAndroid
        }
        return true
    }
    
    var isThisOne: Bool{
        if let isThisOne = _isThisOne{
            return isThisOne
        }
        return false
    }
    
    var name: String{
        if let name = _name {
            return name
        }
        return "Белгісіз"
    }
    
    var rank: String {
        if let rank = _rank {
            return rank
        }
        return "1"
    }
    
    var score: String{
        if let score = _score{
            return score
        }
        return "45"
    }
    
    
    init(isAndroid: Bool?, isThisOne: Bool?, name: String?, rank: Int?, score: Int?){
        _isAndroid = isAndroid
        _isThisOne = isThisOne
        _name = name
        if let myRank = rank{
            _rank = String(myRank)
        }
        if let myScore = score{
            _score = String(myScore)
        }
    }
}
