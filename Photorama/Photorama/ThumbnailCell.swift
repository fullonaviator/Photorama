//
//  ThumbnailCell.swift
//  Photorama
//
//  Created by Burton, Andrew M on 11/14/19.
//  Copyright © 2019 Burton, Andrew M. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
            updateImage(nil)
    }
    
    override func prepareForReuse() {
        updateImage(nil)
    }
    
    
    func updateImage(_ image: UIImage?) {
        imageView.image = image
        
        if image != nil {
            spinner.stopAnimating()
        }
        else {
            spinner.startAnimating()
        }
    }
}
