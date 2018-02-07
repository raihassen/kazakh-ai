//
//  RankViewController.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 02/08/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import UIKit

class RankViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var rankTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getScoreBoard {
            self.rankTableView.reloadData()            
        }
        rankTableView.delegate = self
        rankTableView.dataSource = self
    }
    @IBAction func didSelectHome(_ sender: Any) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func homeButtonIsPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankScoreBoard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCellIdentifier", for: indexPath) as? RankTableViewCell {
            cell.initCell(rankModel: rankScoreBoard[indexPath.row])
            if (rankScoreBoard[indexPath.row].isThisOne){
                cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        } else {
            return RankTableViewCell()
        }
    }
}
