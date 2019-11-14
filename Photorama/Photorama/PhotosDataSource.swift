//
//  PhotosDataSource.swift
//  Photorama
//
//  Created by Burton, Andrew M on 11/14/19.
//  Copyright © 2019 Burton, Andrew M. All rights reserved.
//

import UIKit

class PhotosDataSource: NSObject, UICollectionViewDataSource {
    
    var photos: [Photo] = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath)
        
        return cell
    }
    

    
}
