//
//  CircleView.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-03.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
