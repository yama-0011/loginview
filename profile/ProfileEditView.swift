//
//  ProfileEditView.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import SwiftUI
import FirebaseAuth

struct ProfileEditView: View {
    let original: Profile?
    let onSave: (Profile) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var ageText: String = ""
    @State private var errorMessage: String?

    init(original: Profile?, onSave: @escaping (Profile) -> Void) {
        self.original = original
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("名前（必須）", text: $name)
                    TextField("年齢（任意・半角数字）", text: $ageText)
                        .keyboardType(.numberPad)
                }
                if let err = errorMessage {
                    Text(err).foregroundColor(.red)
                }
            }
            .navigationTitle("編集")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { handleSave() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                name = original?.name ?? ""
                if let age = original?.age { ageText = String(age) }
            }
        }
    }

    private func handleSave() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "名前を入力してください"; return
        }

        let age: Int?
        if ageText.isEmpty {
            age = nil
        } else if let val = Int(ageText), (0...130).contains(val) {
            age = val
        } else {
            errorMessage = "年齢は0〜130の整数で入力してください"; return
        }

        // original が nil の初回作成時は Auth から uid を取得
        var p = original ?? Profile(id: Auth.auth().currentUser?.uid ?? "")
        if p.id.isEmpty { p.id = Auth.auth().currentUser?.uid ?? "" }
        p.name = trimmed
        p.age = age

        onSave(p)
        dismiss()
    }
}
