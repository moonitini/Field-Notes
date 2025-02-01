//
//  FieldNotesApp.swift
//  FieldNotes
//
//  Created by Bona Suh on 12/10/24.
//

import SwiftUI
import Firebase
import FirebaseCore

// App Delegate for handling UIKit lifecycle events
class AppDelegate: NSObject, UIApplicationDelegate {
   // Configure Firebase when app launches
   func application(_ application: UIApplication,
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       FirebaseApp.configure()
       return true
   }
}

// Main app entry point
@main
struct FieldNotesApp: App {
   // Global view model for photo library management
   @StateObject private var viewModel = PhotoLibraryViewModel()
   
   // Initialize app with Firebase configuration
   init() {
       FirebaseApp.configure()  // Initialize Firebase
   }
   
   // Define app's scene structure
   var body: some Scene {
       WindowGroup {
           ContentView()
               .environmentObject(viewModel) // Make view model available throughout app
       }
   }
}
