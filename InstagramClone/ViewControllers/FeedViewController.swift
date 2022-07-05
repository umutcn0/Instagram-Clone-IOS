//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Umut Can on 20.06.2022.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var likeArray = [Int]()
    var commenArray = [String]()
    var identifierArray = [String]()
    var imageArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    func getData(){
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true)
            .addSnapshotListener { Snapshot, error in
            if error != nil {
                print("Error")
            }else{
                if Snapshot != nil && Snapshot?.isEmpty != true{
                    
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.commenArray.removeAll(keepingCapacity: false)
                    self.identifierArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    
                    for document in Snapshot!.documents{
                        let identifierID = document.documentID
                        self.identifierArray.append(identifierID)
                        
                        if let postedBy = document.get("postedBy") as? String,
                           let comment = document.get("postComment") as? String,
                           let imageUrl = document.get("imageUrl") as? String,
                           let likes = document.get("likes") as? Int{
                            self.emailArray.append(postedBy)
                            self.commenArray.append(comment)
                            self.imageArray.append(imageUrl)
                            self.likeArray.append(likes)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.emailLabel.text = self.emailArray[indexPath.row]
        cell.likeLabel.text = String(self.likeArray[indexPath.row])
        cell.commentLabel.text = commenArray[indexPath.row]
        cell.identifierLabel.text = identifierArray[indexPath.row]
        cell.imageCell.sd_setImage(with: URL(string: imageArray[indexPath.row]))
        
        return cell
    }
    
}
