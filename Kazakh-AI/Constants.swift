//
//  Constants.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 27/06/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import UIKit
let progress_default = "progress_default.png"
let correct_color = UIColor.green
let wrong_color = UIColor.red
let progress_correct = "progress_correct.png"
let progress_wrong = "progress_wrong.png"
typealias DownloadComplete = () -> ()
var questionTimer: Timer?
let numberOfQuestions = 1000
let questionMaxScore = 10
let progressInterval = 0.10/Float(questionMaxScore)
var showMessage: Bool?
let device_id: String = (UIDevice.current.identifierForVendor?.uuidString)!
var rankScoreBoard: [rankModel] = []
