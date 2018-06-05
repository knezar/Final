//
//  TableViewController.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/1/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UIViewController {
    
    var ref: DatabaseReference?
    let models =  Models()
    
    var postsData = [Task](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var imageID = [String](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        ref = Database.database().reference()
        loadData()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        }
    
    func loadData() {
        FirebaseAPIClient.manager.loadAllTasks{(tasks, images, error) in
            if let error = error { print(error); return }
            guard let onlineTasks = tasks else { return }
            self.postsData = onlineTasks
            guard let onlineImages = images else { return }
            self.imageID = onlineImages
        }
    }
    
    // MARK: SignOut Button function
    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(initialViewController, animated: false)
    }
}

//MARK: Table View Delegate and Data Source
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellViewID = "textViewCell"
        if postsData[indexPath.row].text == "" {
            cellViewID = "imageViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewID) as! imagePostTableViewCell
            cell.imageLabel.image = NSCacheHelper.manager.getImage(with: imageID[indexPath.row])
            cell.userLabel.text = postsData[indexPath.row].email
            cell.timeStampLabel.text = models.getDateFormatted(from: postsData[indexPath.row].timestamp, format: "M/dd/yy h:mma")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewID) as! textPostTableViewCell
            cell.postLabel.text =  postsData[indexPath.row].text
            cell.userLabel.text = postsData[indexPath.row].email
            cell.timeStampLabel.text = models.getDateFormatted(from: postsData[indexPath.row].timestamp, format: "M/dd/yy h:mm a")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if postsData[indexPath.row].text == ""{
            guard let currentImage = NSCacheHelper.manager.getImage(with: imageID[indexPath.row]) else {return UITableViewAutomaticDimension}
            let imageCrop = currentImage.getCropRatio()
            return 0.66*(tableView.frame.width / imageCrop)
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRation = CGFloat(self.size.width / self.size.height)
        return widthRation
    }
    
}
