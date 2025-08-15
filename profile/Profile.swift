//
//  Profile.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import Foundation

struct Profile: Codable, Identifiable {
    var id: String        // = uid
    var name: String
    var age: Int?

    init(id: String, name: String = "", age: Int? = nil) {
        self.id = id
        self.name = name
        self.age = age
    }
}
