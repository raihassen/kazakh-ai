//
//  sendData.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 20/07/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import Alamofire

/*
 will be saving like this
 "gameId == X"
 "gameIdXquestionNumbers" - int
 "gameId=QuestionNumber="{
 }
 
 */
func postRequest(){
    // IP: 188.226.162.74
    let udid: String = (UIDevice.current.identifierForVendor?.uuidString)!
    let gameId = getCurrentGameId()
    let numberOfQuestions = getQuestionNumberForGame(gameId)
    var scores: [Dictionary<String, Any>] = []
    for question in 0..<numberOfQuestions {
        let key = "gameId=\(gameId)questionId=\(question)"
        let score = UserDefaults.standard.value(forKey: key)
        scores.append(score as! [String : Any])
    }
    let data: Parameters = [
        "device_id": udid,
        "device_type": "ios",
        "lat": UserDefaults.standard.value(forKey: "latitude") as! String,
        "lon": UserDefaults.standard.value(forKey: "longitude") as! String,
        "score": getScore(gameId),
        "lives": getLives(gameId),
        "scores": scores
    ]
   Alamofire.request("\(urlBegins)/send_score", method: .post, parameters: data, encoding:JSONEncoding.default).responseString{ response in
        }
}

func getScore(_ forGameId: Int)->Int{
    if (UserDefaults.standard.value(forKey: "gameId=\(forGameId)score")==nil){
        UserDefaults.standard.set(0, forKey: "gameId=\(forGameId)score")
    }
    return UserDefaults.standard.value(forKey: "gameId=\(forGameId)score") as! Int
}

func getLives(_ forGameId: Int)->Int{
    if (UserDefaults.standard.value(forKey: "gameId=\(forGameId)omir")==nil){
        UserDefaults.standard.set(0, forKey: "gameId=\(forGameId)omir")
    }
    return UserDefaults.standard.value(forKey: "gameId=\(forGameId)omir") as! Int
}

func getCurrentGameId()->Int{
    if (UserDefaults.standard.value(forKey: "currentGameId")==nil){
        UserDefaults.standard.set(0, forKey: "currentGameId")
    }
    return UserDefaults.standard.value(forKey: "currentGameId") as! Int
}

func increaseGameId(){
    UserDefaults.standard.set(getCurrentGameId()+1, forKey: "currentGameId")
}

func getQuestionNumberForGame(_ id:Int)->Int{
    if (UserDefaults.standard.value(forKey: "gameId=\(id)questionNumber")==nil){
        UserDefaults.standard.set(0, forKey: "gameId=\(id)questionNumber")
    }
    return UserDefaults.standard.value(forKey: "gameId=\(id)questionNumber") as! Int
}

func increaseQuestionNumberForGame(_ id: Int){
    UserDefaults.standard.set(getQuestionNumberForGame(id)+1, forKey: "gameId=\(id)questionNumber")
}
