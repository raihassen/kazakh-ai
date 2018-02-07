//
//  getRank.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 02/08/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import Alamofire
func getRank(_ completed: @escaping DownloadComplete){
    let fullURL = urlBegins + "/get_rank?device_id=" + device_id
    Alamofire.request(fullURL).responseJSON { response in        
        let result = response.result
        if let dict = result.value as? Dictionary<String, AnyObject> {
            if let rank = dict["rank"] as? Int {
                UserDefaults.standard.set(rank, forKey: "currentRank")
            }
        }
        completed()
    }
}
