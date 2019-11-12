//
//  ViewController.swift
//  Photorama
//
//  Created by Burton, Andrew M on 11/12/19.
//  Copyright © 2019 Burton, Andrew M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var UIImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        FlickrAPI.fetchInterestingPhotos(page: 3, perPage: 5, completion: { (photosResult) in
            switch photosResult {
            case .success(let photos):
                if let firstPhoto = photos.first,
                    let url_h = firstPhoto.url_h,
                    let url = URL(string: url_h) {
                    FlickrAPI.fetchImage(fromURL: url, completion: { (imageResult) in
                        switch imageResult {
                        case .success(let image):
                            self.UIImage.image = image
                        case .failure(let error):
                            print("fetchImage error = \(error)")
                        }
                    })
                }
            case .failure(let error):
                print("Failure error = \(error.localizedDescription)")
            }
        })
    }
    
}

