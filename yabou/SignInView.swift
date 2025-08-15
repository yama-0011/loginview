//
//  SignInView.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Sign In") {
                    viewModel.signIn(email: email, password: password)
                }

                if viewModel.isAuthenticated {
                    // ログイン後のページに遷移
                    HelloPage(viewModel: viewModel)
                }

                // 新規登録画面への遷移ボタン
                NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                    Text("Create Account")
                        .padding(.top, 16)
                }
            }
        }
    }
}
