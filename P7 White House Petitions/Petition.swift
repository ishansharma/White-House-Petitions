//
//  Petition.swift
//  P7 White House Petitions
//
//  Created by Ishan Sharma on 1/27/20.
//  Copyright © 2020 Ishan Sharma. All rights reserved.
//

struct Petition:Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
