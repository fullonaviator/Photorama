//
//  Models.swift
//  Photorama
//
//  Created by Burton, Andrew M on 11/12/19.
//  Copyright © 2019 Burton, Andrew M. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: String
    var title: String
    var url_h: String?
    var height_h: Int?
    var width_h: Int?
}
struct Photos: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [Photo]
}
struct InterestingListResponse: Codable {
    var photos: Photos
    var stat: String
}


