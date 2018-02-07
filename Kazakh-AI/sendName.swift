//
//  sendName.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 02/08/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import Alamofire
func sendName(name: String){
    let fullUrl = urlBegins + "/update_name?device_id=" + device_id + "&name=" + name
    Alamofire.request(fullUrl).responseString { response in
            print(response)
        }
}
