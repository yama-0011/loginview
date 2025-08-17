//
//  NoteModel.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/17.
//

import FirebaseFirestore

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
}
