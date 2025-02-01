import SwiftUI
import FirebaseAuth

struct ContentView: View {
    // View Model dependencies
    @EnvironmentObject var appViewModel: PhotoLibraryViewModel    // For photo library management
    @StateObject private var userViewModel = UserViewModel()      // For user authentication state
    
    var body: some View {
        VStack {
            // Conditional rendering based on authentication state
            if userViewModel.currentUser == nil {
                // Show sign up/sign in page for unauthenticated users
                SignUpPage()
                    .environmentObject(userViewModel)
            } else {
                // Show main app interface for authenticated users
                MainTabView()
                    .environmentObject(appViewModel)
                    .environmentObject(userViewModel)
            }
        }
        // Check authentication state when view appears
        .onAppear {
            userViewModel.currentUser = Auth.auth().currentUser
        }
    }
}

// SwiftUI preview configuration
#Preview {
    ContentView()
        .environmentObject(PhotoLibraryViewModel())
}
