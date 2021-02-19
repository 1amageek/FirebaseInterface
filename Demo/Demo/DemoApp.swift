//
//  DemoApp.swift
//  Demo
//
//  Created by nori on 2021/02/18.
//

import SwiftUI
import FirebaseFirestore
import FirestoreRepository

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(
//                    Interactor(repository: Repository(doc: Firestore.firestore().collection("aa").document() ))
//                )
        }
    }
}
