//
//  PauseViewController.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 10/07/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {

    @IBOutlet weak var finalSentenceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "currentScore")==nil){
            UserDefaults.standard.set(0, forKey: "currentScore")
        }
        var scoreText = ""
        let finalSentenceText = getText(getCurrentCorrectAnswers())
        if let currentScore = UserDefaults.standard.value(forKey: "currentScore") {
            scoreText = String(describing: currentScore)
        } else {
            scoreText = "0"
        }
        scoreLabel.text = scoreText
        finalSentenceLabel.text = finalSentenceText
        initGameSettings()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func initGameSettings(){
        UserDefaults.standard.set(0, forKey: "currentScore")
        UserDefaults.standard.set(3, forKey: "omir")
    }
    
    func getText(_ correct_answers: Int)->String{
        let AI = "Робот"
        let ABAI = "Абай"
        let AI_DI = AI + "ты"
        let AI_DIN = AI + "тың"
        let ABAI_DI = ABAI + "ды"
        let ABAI_DAN = ABAI + "дан"
        let lives = getNumberOfLives()
        var final_text = ""
        if (correct_answers <= 0) {
            final_text = "Күте тұрыңыз! Бұл қалжын емес! " +
                AI + " соншама жақсы бола ала ма?";
        } else if (correct_answers == 1) {
            final_text = "Не деген керемет " + AI + " ...";
        } else if (correct_answers >= 2 && correct_answers <= 6) {
            final_text = "Өкінішке орай сіз " + AI_DI + " " + ABAI_DAN + " ажырата алмадыңыз!";
        } else if (correct_answers >= 7 && correct_answers <= 10) {
            final_text = "Құттықтаймыз! Сіз " + ABAI_DI + " жақсы меңгергенсіз!";
            if (lives < 3) {
                final_text += " Бірақ та " + AI_DI + " кейбір сұрақтарда ажырата алмадыңыз..";
            }
        } else if (correct_answers >= 11 && correct_answers <= 20) {
            final_text = "Керемет! Мәәә Сіз " + ABAI_DI + " жетік меңгергенсіз!";
            if (lives < 3) {
                final_text += " Бірақ та кейбір сұрақтарда қателестіңіз. Мүмкін асығып қойдыңыз..";
            }
        } else if (correct_answers >= 21 && correct_answers <= 40) {
            final_text = "Уаау! Сіз " + ABAI_DI + " жатқа білетін боласыз?!";
            if (lives < 3) {
                final_text += " Бірақ та кейбір сұрақтарда қателестіңіз. Мүмкін ойынды тезірек бітіргіңіз келді :)";
            }
        } else if (correct_answers >= 41 && correct_answers <= 70) {
            final_text = "Білесіз бе?! Сіз бір қара сөз жазып көріңіз! Шынымен сізде өте керемет талант бар :)";
        } else if (correct_answers >= 71 && correct_answers <= 160) {
            final_text = "Cөзіміз таусылды.. Сіз " + ABAI_DI + " жатқа білесіз! Және міндетті түрде қара сөз жазып көріңіз :)";
        } else if (correct_answers >= 161) {
            final_text = "Сіз сияқты " + ABAI_DI + " супер білетін адамдар тұрғанда " + AI_DIN + " дәуірі әлі өөөте алыс!" ;
        }
        return final_text
    }
    
    @IBAction func shareButtonIsPressed(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()        
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image!)
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func homeButtonIsPressed(_ sender: Any) {
        let vc: UIViewController! = self.storyboard?.instantiateInitialViewController()
        show(vc, sender: vc)
    }
    
    func getCurrentCorrectAnswers()->Int{
        let key = "currentCorrectAnswers"
        if (UserDefaults.standard.value(forKey: key)==nil){
            UserDefaults.standard.set(0, forKey: key)
        }
        return UserDefaults.standard.value(forKey: key) as! Int
    }
    
    func getNumberOfLives()->Int{
        if (UserDefaults.standard.value(forKey: "omir") == nil){
            UserDefaults.standard.set(3, forKey: "omir")
        }
        return UserDefaults.standard.value(forKey: "omir") as! Int
    }

}
