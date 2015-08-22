//
//  PhotoViewCell.swift
//  CollectionAssets
//
//  Created by Kristian Secor on 2/25/15.
//  Copyright (c) 2015 Kristian Secor. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var checkedImageView: UIImageView!
    
    var _checked: Bool!
    var checked: Bool {
        get {
            return _checked
        }
        set(value) {
            _checked = value
            if checkedImageView != nil {
                checkedImageView.hidden = !value
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checked = false
    }
}
