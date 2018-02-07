//
//  RankTableViewCell.swift
//  Kazakh-AI
//
//  Created by Raikhan Khassenova on 02/08/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var deviceTypeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(id: Int, isAndroid: Bool, name: String, score: Int){
        idLabel.text = String(id)
        nameLabel.text = name
        scoreLabel.text = String(score)
    }
    
    func initCell(rankModel: rankModel){
        idLabel.text = rankModel.rank
        nameLabel.text = rankModel.name
        scoreLabel.text = rankModel.score
        if (rankModel.isAndroid){
            deviceTypeImage.image = UIImage(named: "android.png")
            deviceTypeImage.contentMode = .scaleAspectFill
        } else {
            deviceTypeImage.image = UIImage(named: "ios")
            deviceTypeImage.contentMode = .scaleAspectFit
        }
    }

}
