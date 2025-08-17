//
//  EditNoteView.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/17.


import SwiftUI

struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var firestoreViewModel: FirestoreViewModel

    // ← id/title/content をまとめて扱う
    @State private var note: Note

    // 親から受け取った Note で @State を初期化
    init(firestoreViewModel: FirestoreViewModel, note: Note) {
        self.firestoreViewModel = firestoreViewModel
        _note = State(initialValue: note)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note Details")) {
                    TextField("Title", text: $note.title)
                    TextEditor(text: $note.content)
                        .frame(minHeight: 160)
                }

                Button("Save") {
                    // Firestore 上書き更新
                    firestoreViewModel.updateNote(note: note)
                    dismiss()
                }
            }
            .navigationTitle("Edit")
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}
