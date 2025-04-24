//
//  BookishApp.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
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
struct BookishApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var authViewModel = AuthViewModel()
  
    var body: some Scene {
        WindowGroup {
          if authViewModel.user != nil {
              ContentView()
                  .environmentObject(authViewModel)
          } else {
              LoginView()
                  .environmentObject(authViewModel)
          }
        }
    }
}
