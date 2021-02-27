//
//  DetailViewController.swift
//  SwiftSNS
//
//  Created by yasuyoshi on 2021/02/27.
//

import UIKit
//
import SDWebImage

class DetailViewController: UIViewController {
    //
    var userName = String()
    var profileImageString = String()
    var contentImageStrig = String()
    var comment = String()
    //
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.sd_setImage(with: URL(string: profileImageString), completed: nil)
        userNameLabel.text = userName
        contentImageView.sd_setImage(with: URL(string: contentImageStrig), completed: nil)
        commentLabel.text = comment
        
    }

}
