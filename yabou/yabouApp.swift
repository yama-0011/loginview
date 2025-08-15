//
//  yabouApp.swift
//  yabou
//
//  Created by 山上尚真 on 2025/08/15.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct SwiftUiFirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isAuthenticated {
                    HelloPage(viewModel: viewModel)
                } else {
                    SignInView(viewModel: viewModel)
                }
            }
            .onAppear {
                print("起動時 UID:", viewModel.userID ?? "nil")
            }
            .onChange(of: viewModel.userID) { newValue in
                print("UIDが更新されました:", newValue ?? "nil")
            }
        }
    }
}
