import FirebaseAuth
import SwiftUI

class UserViewModel: ObservableObject {
   // Published user state for authentication status
   @Published var currentUser: User?
   
   // Handle new user registration with email/password
   func signUp(with email: String, password: String) async {
       do {
           // Create new Firebase Auth user
           let result = try await Auth.auth().createUser(withEmail: email, password: password)
           // Update UI state on main thread
           DispatchQueue.main.async {
               self.currentUser = result.user
           }
       } catch {
           print("Sign-up error: \(error)")
       }
   }
   
   // Handle existing user sign in with email/password
   func signIn(with email: String, password: String) async {
       do {
           // Sign in existing Firebase Auth user
           let result = try await Auth.auth().signIn(withEmail: email, password: password)
           // Update UI state on main thread
           DispatchQueue.main.async {
               self.currentUser = result.user
           }
       } catch {
           print("Sign-in error: \(error)")
       }
   }
   
   // Handle user sign out
   func signOut() {
       do {
           // Sign out current Firebase Auth user
           try Auth.auth().signOut()
           // Clear user state on main thread
           DispatchQueue.main.async {
               self.currentUser = nil
           }
       } catch {
           print("Sign-out error: \(error)")
       }
   }
}
