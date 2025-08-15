//
//  HelloPage.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import SwiftUI

// ログイン後の画面
struct HelloPage: View {
    var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Hello, you're logged in!")
                .font(.title)
                .padding()
            Button("Log Out") {
                // ログアウトしてログイン画面へ遷移する
                viewModel.signOut()
            }
        }
    }
}
