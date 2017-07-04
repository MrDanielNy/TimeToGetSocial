//
//  FeedCell.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-03.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImage.image = img
        } else {
            let imageUrl = post.imageUrl
            let ref = Storage.storage().reference(forURL: imageUrl)
            
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("ADGJMP: Uanble to download the image from storage")
                } else {
                    print("ADGJMP: Image downloaded from Storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                        
                    }
                }
            })
        }
    }

}
