//
//  FirebaseAPIClient.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
typealias TasksCallback = ([Task]?, Error?) -> Void

enum AppError: Error {
    case invalidChildren
    case invalidValue
}

class FirebaseAPIClient {
    static let manager = FirebaseAPIClient()
    private init() {}
//    func login(with email: String, and password: String, completion: @escaping (User, Error) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            guard let user = user else {return}
//            guard let error = error else {return}
//            completion(user, error)
//        }
//    }
//    func createAccount(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//        })
//    }
    
    func loadAllTasks(completionHanlder: @escaping ([Task]?, [String]?, Error?) -> Void) {
        let ref = Database.database().reference().child("tasks")
        ref.observe(.value){(snapShot: DataSnapshot) in
            guard let childSnapShots = snapShot.children.allObjects as? [DataSnapshot] else {
                completionHanlder(nil, nil, AppError.invalidChildren)
                return
            }
            var allTasks = [Task]()
            var allImageData = [String]()
            for snap in childSnapShots {
                guard let rawJSON = snap.value else { continue }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let task = try JSONDecoder().decode(Task.self, from: jsonData)
                    if task.text == "" {
                        allImageData.append(snap.key)
                        self.DownloadImage(childRef: snap.key)
                    } else {
                       allImageData.append(" test ")
                    }
                    allTasks.append(task)
                }
                catch {
                    print(error)
                }
            }
            completionHanlder(allTasks, allImageData, nil)
        }
    }

    
    func createTasks(task: Task) {
        let ref = Database.database().reference().child("tasks")
        ref.childByAutoId().setValue(task.toJSON())
    }
    
    func logOutCurrentUser() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
    }
    
    func UploadImage(task: Task, image: UIImage) {
        // get image data
//        let imageURLString = "https://www.gizmochina.com/wp-content/uploads/2018/02/WWDC-2018.jpg"
        
        let ref = Database.database().reference().child("tasks").childByAutoId()
        ref.setValue(task.toJSON())
        
        //        let imageURL = URL(string: imageURLString)!
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            //= try! Data.init(contentsOf: imageURL)
            
            // gets root reference from Storage
            let storageRef = Storage.storage().reference()
            
            // Create a reference to the file you want to upload
            let uploadImageRef = storageRef.child(ref.key)
            
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // Upload the file to the path "images/someImaage.jpg"
            let _ = uploadImageRef.putData(imageData, metadata: metadata)
        }
    }
    
    
    func DownloadImage(childRef: String) {
        // gets root reference from Storage
        let storageRef = Storage.storage().reference()
        // Create a reference to the file you want to upload
        let downloadImageRef = storageRef.child(childRef)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            downloadImageRef.getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.DownloadImage(childRef: childRef)
                }
            } else if let data = data {
                let image = UIImage.init(data: data)
                NSCacheHelper.manager.addImage(with: childRef, and: image!)
            }
            
        }
        return

    }
}
