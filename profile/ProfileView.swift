//
//  ProfileView.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var profile: Profile?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showEditor = false

    private let service = ProfileService()

    var body: some View {
        VStack(spacing: 12) {
            if isLoading {
                ProgressView("読み込み中…")
            } else if let p = profile {
                VStack(alignment: .leading, spacing: 8) {
                    Text("名前: \(p.name)").font(.title3)
                    Text("年齢: \(p.age.map(String.init) ?? "未設定")")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("プロフィールが未作成です。右上の Edit から作成してください。")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let err = errorMessage {
                Text(err).foregroundColor(.red).font(.footnote)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("プロフィール")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showEditor = true }
            }
        }
        .task { await load() }
        .refreshable { await load() }
        .sheet(isPresented: $showEditor) {
            ProfileEditView(original: profile) { updated in
                Task {
                    do {
                        try await service.save(uid: updated.id, profile: updated)
                        profile = updated
                    } catch {
                        errorMessage = "保存に失敗: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    private func load() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "ログイン情報が見つかりません"; return
        }
        isLoading = true; defer { isLoading = false }
        errorMessage = nil
        do {
            profile = try await service.load(uid: uid) ?? Profile(id: uid)
        } catch {
            errorMessage = "読み込みに失敗: \(error.localizedDescription)"
        }
    }
}
