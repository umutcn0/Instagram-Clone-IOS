//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Umut Can on 20.06.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardGesture)

    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    

    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let folder = storageRef.child("Image")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let image = folder.child("\(uuid).jpg")
            
            //STORE'A IMAGE EKLEME İŞLEMLERİ
            
            image.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    image.downloadURL { url, error in
                        if error == nil{
                            let url = url?.absoluteString
                            
                            //FİREBASE DATASTORE İŞLEMLERİ
                            
                            let firebase = Firestore.firestore()
                            var firebaseRef : DocumentReference? = nil
                            
                            let firebasePost = ["date" : FieldValue.serverTimestamp(), "imageUrl" : url!, "postedBy" : Auth.auth().currentUser!.email!,"likes" : 0, "postComment" : self.commentText.text!] as [String : Any]
                            
                            firebaseRef = firebase.collection("Posts").addDocument(data: firebasePost)
                            
                            self.imageView.image = UIImage(named: "select")
                            self.commentText.text = ""
                            self.tabBarController?.selectedIndex = 0 // Tap bar üzerindeki 0. indexe gittik
                            
                        }else{
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        }
                            
                        }
                    
                    }
            }
        }
    }
}
