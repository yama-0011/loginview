//
//  FContentView.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/17.
//

import SwiftUI

struct FContentView: View {
    @StateObject private var firestoreViewModel = FirestoreViewModel()
    @State private var showingAddNote = false

    // ← これが「今編集したいNote」。nilなら非表示、入ればシート表示
    @State private var noteToEdit: Note? = nil

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(firestoreViewModel.notes) { note in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(note.title).font(.headline)
                                Text(note.content).font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Delete") {
                                firestoreViewModel.deleteNote(note: note)
                            }
                        }
                        .swipeActions {
                            Button("Edit") {
                                // ← ここで対象をセット → sheet(item:) が開く
                                noteToEdit = note
                            }
                            .tint(.blue)
                        }
                    }
                }
                .navigationTitle("Notes")
                .navigationBarItems(trailing: Button(action: {
                    showingAddNote = true
                }) {
                    Image(systemName: "plus")
                })
                .onAppear {
                    firestoreViewModel.getNotes()
                }
                // 追加（新規作成）
                .sheet(isPresented: $showingAddNote) {
                    AddNoteView(firestoreViewModel: firestoreViewModel)
                }
                // 編集（対象Noteありのときだけ）
                .sheet(item: $noteToEdit) { note in
                    EditNoteView(firestoreViewModel: firestoreViewModel, note: note)
                }
            }

            Button(action: { authViewModel.signOut() }) {
                Text("Sign Out")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
    }
}
