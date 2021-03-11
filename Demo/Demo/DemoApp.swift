//
//  DemoApp.swift
//  Demo
//
//  Created by nori on 2021/02/18.
//

import SwiftUI
import Firebase
import FirestoreRepository


@main
struct DemoApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Interactor(repository: Repository(userID: "aa")))
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
