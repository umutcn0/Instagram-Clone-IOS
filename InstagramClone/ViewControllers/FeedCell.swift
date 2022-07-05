//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Umut Can on 23.06.2022.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeClicked(_ sender: Any) {
        print("Clicked")
        let firebaseDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount+1 ] as [String : Any]
            
            firebaseDatabase.collection("Posts").document(identifierLabel.text!).setData(likeStore, merge: true)
        }
    }
    
}
