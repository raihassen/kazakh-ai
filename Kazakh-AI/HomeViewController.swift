//
//  HomeViewController.swift
//  
//
//  Created by Raikhan Khassenova on 10/07/2017.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.delegate = self
        displayNameAndShowRank()
        if (showMessage == true){
            showMessage = false
            showToast("Интернет байланысы жоқ")
        }
        if (!hasLocation()){
            getLocation()
        }
    }
    
    func displayNameAndShowRank(){
        if (UserDefaults.standard.value(forKey: "PlayerName")==nil){
            UserDefaults.standard.set("", forKey: "PlayerName")
        }
        var player_name = UserDefaults.standard.value(forKey: "PlayerName") as? String
        if (player_name != ""){
            player_name = player_name! + ", "
        }
        getRank {
            if (UserDefaults.standard.value(forKey: "currentRank")==nil){
                UserDefaults.standard.set(0, forKey: "currentRank")
            }
            let rank_value = UserDefaults.standard.value(forKey: "currentRank") as! Int
            let rankLabelText = player_name! + "Cіз " + String(rank_value) + " орындасыз. \nҚұттықтаймыз!"
            self.rankLabel.text = rankLabelText
        }
    }
    
    
    @IBAction func nameEditingDidBegin(_ sender: Any) {
        print("I am editing")
    }
    
    @IBAction func nameFieldDidFinishEditing(_ sender: Any) {
        UserDefaults.standard.set(nameTextField.text, forKey: "PlayerName")
        displayNameAndShowRank()
        sendName(name: nameTextField.text!)
    }
    
    @IBAction func playButtonIsPressed(_ sender: Any) {      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
    }
    
    func getLocation(){
        print("getting location")
            locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        var latitudeString = "0"
        var longitudeString = "0"
        if (status == .authorizedWhenInUse || status == .authorizedAlways){
            if let latitude = locationManager.location?.coordinate.latitude{
                latitudeString = String(latitude)
            }
            if let longitude = locationManager.location?.coordinate.longitude{
                longitudeString = String(longitude)
            }
        }
        UserDefaults.standard.set(latitudeString, forKey: "latitude")
        UserDefaults.standard.set(longitudeString, forKey: "longitude")
    }
    
    func hasLocation()->Bool{
        return (hasElementBy("latitude")&&hasElementBy("longitude"))
    }
    
    func hasElementBy(_ key:String)->Bool{
        if let val = UserDefaults.standard.value(forKey: key) as? String{
            if (val != "0") {
                return true;
            }
        }
        return false;
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension UIViewController {
    
    func showToast(_ message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-500, width: 200, height: 70))
        toastLabel.numberOfLines = 2
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
