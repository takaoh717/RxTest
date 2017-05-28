//
//  GithubUserCell.swift
//  RxTest
//
//  Created by Takao on 2017/05/10.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import UIKit
import Kingfisher

class GithubUserCell: UITableViewCell, Nibable {

    static let defaultHeight: CGFloat = 80
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = UIColor(github: .blue)
        urlLabel.textColor = UIColor(github: .textGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with user: GithubUser) {
        iconImageView.kf.cancelDownloadTask()
        nameLabel.text = user.login
        urlLabel.text = user.htmlUrl.absoluteString
        iconImageView.kf.setImage(with: user.avatarUrl, options: [.transition(.fade(0.3))])
    }
    
}
