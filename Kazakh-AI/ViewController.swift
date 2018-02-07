//
//  ViewController.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 26/06/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var finishButton: UIView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var abaibutton: UIButton!
    @IBOutlet weak var aibutton: UIButton!
    @IBOutlet weak var questionProgessView: UIProgressView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        questionProgessView.transform = questionProgessView.transform.scaledBy(x: 1, y: 9)
    }
    override func viewDidAppear(_ animated: Bool) {
        updateScoreLabel(String(getCurrentScore()))
        updateomirLabel(getNumberofomirs())
        getQuestions()
    }
    @IBAction func homeButtonIsPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        increasequestionId()
    }
    
    @IBAction func finishButtonIsPressed(_ sender: UIButton) {
        if (questionTimer != nil){
             questionTimer?.invalidate()
        }
    }
    
    @IBAction func aiButtonIsPressed(_ sender: Any) {
        animateAndShowNextQuestion(aibutton)
    }
    
    @IBAction func abaiButtonIsPressed(_ sender: Any) {
        animateAndShowNextQuestion(abaibutton)
    }
    
    func getQuestionsDatabaseFromInternet(_ completed: @escaping DownloadComplete) {
        Alamofire.request(appEngineUrl + "\(numberOfQuestions)").responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let status = dict["status"] as? String{
                    if status == "success" {
                        UserDefaults.standard.set(true, forKey: "isDataLoaded")
                        if let questions = dict["questions"] as? [Dictionary<String, AnyObject>] {
                            var count = 0;
                            for question in questions {
                                UserDefaults.standard.set(question["sentence"], forKey: "sentence\(count)")
                                UserDefaults.standard.set(question["is_real"], forKey: "isReal\(count)")
                                UserDefaults.standard.set(question["id"], forKey: "id\(count)")
                                count += 1
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
    
    func getQuestions(){
        /*
         1. check if data is loaded
         2. if yes, then show questions
         3. if no, check if internet is avaibla
         4. if yes, downlaod from internet
         5. if no, return to main page, and display that no questions
         */
        if (UserDefaults.standard.value(forKey: "isDataLoaded") as? Bool) == nil {
            if (isInternetAvailable()){
                getQuestionsDatabaseFromInternet {
                    self.showQuestion()
                }
            } else {
                showMessage = true
                dismiss(animated: true, completion: nil)
            }
        } else {
            showQuestion()
        }
    }
    
    func updateQuestionUI(_ id: Int){
        let sentence = UserDefaults.standard.value(forKey: "sentence\(id)")
        sentenceLabel.text = sentence as? String
    }
    
    func changeButtonsEnabledState(_ shouldEnable: Bool){
        abaibutton.isEnabled = shouldEnable
        aibutton.isEnabled = shouldEnable
    }
    
    func animateButton(_ sender: UIButton, value: Bool){
        var buttonAnimationColor: UIColor?
        let buttonInitialColor = UIColor.white
        let scoreLabelInitialColor = UIColor.black
        abaibutton.isEnabled = false
        
        if (value==true){
            buttonAnimationColor = UIColor.green
        } else{
            buttonAnimationColor = UIColor.red
        }
        changeButtonsEnabledState(false)
        let _currentQuestionScore = currentQuestionScore(value)
        if (_currentQuestionScore > 0) {
            updateScoreLabel("+" + String(_currentQuestionScore))
        }
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            sender.backgroundColor = buttonAnimationColor            
            self.scoreLabel.textColor = buttonAnimationColor
        }) { (Bool) -> Void in
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                sender.backgroundColor = buttonInitialColor
                self.scoreLabel.textColor = scoreLabelInitialColor
            }, completion: { (Bool) -> Void in
                // When button finishes blinking, show next question
                self.showQuestion()
                let newScore = self.getCurrentScore() + _currentQuestionScore
                self.updateScoreLabel(String(newScore))
                self.setCurrentScore(Int(newScore))
                self.changeButtonsEnabledState(true)
            })
        }
    }
    
    func showQuestion() {
        increasequestionId()
        updateQuestionUI(getquestionId())
        initProgressView()
        startTimer()
    }
    
    func startTimer() {
        questionTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                             target: self,
                                             selector: #selector(ViewController.updateProgressView),
                                             userInfo: nil,
                                             repeats: true)
    }
    
    func saveQuestionData(_ question_id: Int, is_correct: Bool, date:String){
        var is_correct_int: Int
        if (is_correct){
            is_correct_int = 1
        } else {
            is_correct_int = 0
        }
        let questionInfo: Dictionary<String, Any> = [
            "question_id": question_id,
            "is_correct": is_correct_int,
            "date_ans": convertDate2String(Date())
        ]
        let gameId = getCurrentGameId()
        let questionNumber = getQuestionNumberForGame(gameId)
        let key = "gameId=\(gameId)questionId=\(questionNumber)"        
        UserDefaults.standard.set(questionInfo, forKey: key)
        increaseQuestionNumberForGame(gameId)
    }
    
    func animateAndShowNextQuestion(_ sender: UIButton){
        stopTimer()
        
        if let isReal = UserDefaults.standard.value(forKey: "isReal\(getquestionId())") as? Bool {
            let question_id_server = UserDefaults.standard.value(forKey: "id\(getquestionId())") as! Int
            let questionAnsweredCorrectly = (isReal==true && sender == abaibutton) || (isReal==false && sender == aibutton)
            saveQuestionData(question_id_server, is_correct: questionAnsweredCorrectly, date: Date().debugDescription+"hi")
            if (!questionAnsweredCorrectly){
                decreaseomir()
                updateomirLabel(getNumberofomirs())
            } else {
                incCurrentCorrectAnswers()
            }
            animateButton(sender, value: questionAnsweredCorrectly)
            if (getNumberofomirs()==0){
                performSegue(withIdentifier: "Finish", sender: nil)
            }
        }
    }
    
    func stopTimer() {
        if (questionTimer != nil) {
            questionTimer?.invalidate()
        }
    }
    
    func getCurrentScore()->Int {
        if (UserDefaults.standard.value(forKey: "currentScore") == nil){
            UserDefaults.standard.set(0, forKey: "currentScore")
        }
        return UserDefaults.standard.value(forKey: "currentScore") as! Int
    }
    
    func setCurrentScore(_ value: Int){
        UserDefaults.standard.set(value, forKey: "currentScore")
    }
    
    func currentQuestionScore(_ result: Bool)->Int{
        if (result){
            let score = questionProgessView.progress * Float(questionMaxScore)
            return Int(score)
        } else {
            return 0
        }
    }
    
    func updateScoreLabel(_ value: String) {
        scoreLabel.text = value
        // TODO: make it animated
        // TODO: "+score" should be different from "current_score", may be size
    }
    
    func initProgressView() {
        questionProgessView.progress = 1.00
    }
    
    @objc func updateProgressView() {
        let currentProgress = questionProgessView.progress
        if (currentProgress > 0){
            questionProgessView.progress = currentProgress - progressInterval
        } else {
            questionTimer?.invalidate()
        }
    }
    
    func getquestionId()->Int{
        if (UserDefaults.standard.value(forKey: "questionId") == nil) {
            UserDefaults.standard.set(0, forKey: "questionId")
        }
        return UserDefaults.standard.value(forKey: "questionId") as! Int
    }
    
    func increasequestionId() {
        var newquestionId = getquestionId() + 1
        if (newquestionId == numberOfQuestions){
            // TODO: change user defaults isDataLoaded for false
            // TODO: call getQuestions function then
            getQuestionsDatabaseFromInternet {
                newquestionId = newquestionId % numberOfQuestions
                // TODO: what should we do?
                UserDefaults.standard.setValue(newquestionId, forKey: "questionId")
            }
        } else {
            UserDefaults.standard.setValue(newquestionId, forKey: "questionId")
        }
    }
    
    func isInternetAvailable()->Bool{
        return (currentReachabilityStatus != .notReachable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Finish") {
            saveOmirWith(getCurrentGameId())
            saveFinalScore(getCurrentGameId())
            postRequest()
            increaseGameId()
        }
    }
    
    func getNumberofomirs()->Int{
        if let omir = UserDefaults.standard.value(forKey: "omir")as? Int{
            if (omir>=0 && omir<4){
                return omir;
            }
        }
        UserDefaults.standard.set(3, forKey: "omir")
        return 3;
    }
    
    func decreaseomir(){
        UserDefaults.standard.set(getNumberofomirs()-1, forKey: "omir")
    }
    
    @IBOutlet weak var omirLabel: UILabel!
    func updateomirLabel(_ number: Int){
        omirLabel.text = "x"+String(number)
    }
    
    func convertDate2String(_ date: Date)->String{
        var result = ""
        var i = 0
        for character in date.description.characters {
            result = result + String(character)
            i = i+1
            if (i==19) {
                break
            }
        }
        return result
    }
    
    func saveOmirWith(_ gameId: Int){
        let key = "gameId=\(gameId)omir"
        UserDefaults.standard.set(getNumberofomirs(), forKey: key)
    }
    
    func saveFinalScore(_ forGameId: Int){
        let key = "gameId=\(forGameId)score"
        UserDefaults.standard.set(getCurrentScore(), forKey: key)
    }
    
    func getCurrentCorrectAnswers()->Int{
        let key = "currentCorrectAnswers"
        if (UserDefaults.standard.value(forKey: key)==nil){
            UserDefaults.standard.set(0, forKey: key)
        }
        return UserDefaults.standard.value(forKey: key) as! Int
    }
    
    func incCurrentCorrectAnswers(){
        let key = "currentCorrectAnswers"
        UserDefaults.standard.set(getCurrentCorrectAnswers()+1, forKey: key)
    }
}
