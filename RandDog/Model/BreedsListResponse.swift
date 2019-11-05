//
//  BreedsListResponse.swift
//  RandDog
//
//  Created by Akan Akysh on 8/22/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let message: [String: [String]]
    let status: String
}
