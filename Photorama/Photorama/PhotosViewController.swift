//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Burton, Andrew M on 11/14/19.
//  Copyright © 2019 Burton, Andrew M. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photosDataSource = PhotosDataSource()  //???
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photosDataSource
        collectionView.delegate = self
        
        FlickrAPI.fetchInterestingPhotos(page: 1, perPage: 100, completion: { (photosResult) in  //How can we change here and change the number of cells/
            switch photosResult {
            case .success(let photos):
                self.photosDataSource.photos = photos
            case .failure(_):
                self.photosDataSource.photos = []
            }
            self.collectionView.reloadData()
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard  indexPath.item < photosDataSource.photos.count else {
            return
        }
        
        let photo = photosDataSource.photos[indexPath.item]
        
        
        guard let  urlString = photo.url_h,
            let url = URL(string: urlString) else {
                return
        }
        
        guard let thumbnailCell = cell as? ThumbnailCell else {
            return
        }
        
        
        FlickrAPI.fetchImage(fromURL: url) { (ImageResult) in
            switch ImageResult {
            case .success(let image):
                thumbnailCell.updateImage(image)
            default:
                break
            }
        }
    
}

}
