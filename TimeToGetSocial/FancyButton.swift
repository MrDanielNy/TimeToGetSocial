//
//  FancyButton.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-02.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

import UIKit

@IBDesignable
class FancyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        
        
        
    }

}
