//
//  FeedVC.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-03.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: UITextField!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imagePicker: UIImagePickerController!

    var posts = [Post]()
    
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataSerivce.ds.REF_POSTS.observe(.value , with: { (snapshot) in
            
            self.posts = []
            
            if let postsFromDB = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in postsFromDB {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("ADGJMP: Did not select a valid image")
        }
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func signoutBtnTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignin", sender: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("ADGJMP: U must write something i the textfield before posting")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("ADGJMP: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUuid = NSUUID().uuidString
            let imageMeta = StorageMetadata()
            imageMeta.contentType = "image/jpeg"
            
            DataSerivce.ds.REF_POST_IMG.child(imgUuid).putData(imageData, metadata: imageMeta) { (imageMeta, error) in
                if error != nil {
                    print("ADGJMP: Unable to upload image to Storage \(String(describing: error))")
                } else {
                    print("ADGJMP: Success in uploading image to storage")
                    let downloadUrl = imageMeta?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(imageUrl: url)
                    }
                }
                
                
            }
            
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataSerivce.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    //It´s a must for tableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? FeedCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return FeedCell()
        }
    }
    

}
