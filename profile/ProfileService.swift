//
//  ProfileService.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import Foundation
import FirebaseFirestore

final class ProfileService {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("profiles") }

    func load(uid: String) async throws -> Profile? {
        let snap = try await col.document(uid).getDocument()
        guard snap.exists, let data = snap.data() else { return nil }
        let name = data["name"] as? String ?? ""
        let age  = data["age"] as? Int
        return Profile(id: uid, name: name, age: age)
    }

    func save(uid: String, profile: Profile) async throws {
        var dict: [String: Any] = ["name": profile.name]
        if let age = profile.age { dict["age"] = age }
        try await col.document(uid).setData(dict, merge: true)
    }
}
