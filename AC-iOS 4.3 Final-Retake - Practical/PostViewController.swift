//
//  PostViewController.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/1/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostViewController: UIViewController{

    @IBOutlet weak var textViewPost: UITextView!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var middleTextLabel: UILabel!
    
    var ref: DatabaseReference?
    let controller = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPost.delegate = self
        textViewPost.layer.borderWidth = 1
        textViewPost.layer.cornerRadius = 10
        textViewPost.layer.borderColor = UIColor.darkGray.cgColor
        addImage.layer.borderWidth = 1
        addImage.layer.cornerRadius = 10
        addImage.layer.borderColor = UIColor.darkGray.cgColor
        ref = Database.database().reference()
        
    }
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        middleTextLabel.text = "- OR -"
        textViewPost.resignFirstResponder()
        if !textViewPost.text.isEmpty {
            textViewPost.text = ""
        }
        
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
        textViewPost.resignFirstResponder()
        let timeStamp = Date().timeIntervalSince1970
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email!
            var metaData = ""
            let message = "Your Post Has Been Published"
            let avc = UIAlertController(title: "Published", message: message, preferredStyle: .alert)
            avc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(avc, animated: true, completion: nil)
            
            if !textViewPost.text.isEmpty {
                metaData = "text"
                let postObject = Task(email: email, text: textViewPost.text!, timestamp: timeStamp, type: metaData, userId: uid)
                FirebaseAPIClient.manager.createTasks(task: postObject)
                
            } else if addImage.image != nil {
                metaData = "image"
                let postObject = Task(email: email, text: textViewPost.text!, timestamp: timeStamp, type: metaData, userId: uid)
                FirebaseAPIClient.manager.UploadImage(task: postObject, image: addImage.image!)
            } else {
                middleTextLabel.text = "Add an Image or Text"
            }
        }
    }
    
}

extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        middleTextLabel.text = "- OR -"
        addImage.image = nil
    }
}

extension PostViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"]
        addImage.image = image as? UIImage
        dismiss(animated: true, completion: nil)
    }
}


