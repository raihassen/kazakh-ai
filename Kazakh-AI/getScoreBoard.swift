//
//  getScoreBoard.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 03/08/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import Alamofire
func getScoreBoard(_ completed: @escaping DownloadComplete){
    rankScoreBoard = []
    let fullURL = urlBegins + "/get_top_correct?count=10&device_id=" + device_id    
    Alamofire.request(fullURL).responseJSON { response in
        let result = response.result
        if let dict = result.value as? Dictionary<String, AnyObject> {
            if let rankings = dict["ranking"] as? [Dictionary<String, AnyObject>] {
                for ranking in rankings{
                    let deviceType = ranking["device_type"] as? String
                    let isThisOne = ranking["is_this_one"] as? Bool
                    let name = ranking["name"] as? String
                    let rank = ranking["rank"] as? Int
                    let score = ranking["score"] as? Int
                    let myRankModel = rankModel.init(isAndroid: deviceType=="android", isThisOne: isThisOne, name: name, rank: rank, score: score)
                    rankScoreBoard.append(myRankModel)
                }
            }
        }
        completed()
    }
}
