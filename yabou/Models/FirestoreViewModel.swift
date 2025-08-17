//
//  FirestoreViewModel.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/17.
//

import FirebaseFirestore

class  FirestoreViewModel : ObservableObject {
    private  var db =  Firestore.firestore()
    @Published  var notes = [Note]()
    
    // ノートを読み取り
    func  getNotes () {
        db.collection( "notes" ).order(by: "title" ).addSnapshotListener { snapshot, error in
            if  let error = error {
                print ( "ノートの取得エラー: \(error) " )
                return
            }
            
            self.notes = snapshot?.documents.compactMap { document in
                try? document.data(as: Note.self )
            } ?? []
        }
    }
    
    // ノートの作成
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        
        do {
            _ = try db.collection("notes").addDocument(from: newNote)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    // ノートの削除
    func deleteNote(note: Note) {
        guard let noteID = note.id else { return }
        
        db.collection("notes").document(noteID).delete { error in
            if let error = error {
                print("Error deleting note: \(error)")
            }
        }
    }
    
    // ノートの更新
    func updateNote(note: Note) {
        guard let noteID = note.id else { return }
        
        do {
            try db.collection("notes").document(noteID).setData(from: note)
        } catch {
            print("Error updating note: \(error)")
        }
    }
}
