import SwiftUI

struct SignUpPage: View {
    //  - View Model Dependencies
    // UserViewModel for handling authentication, injected via environment
    @EnvironmentObject var userViewModel: UserViewModel
    // JokeViewModel for fetching and displaying random jokes
    @StateObject private var jokeViewModel = JokeViewModel()
    
    //  - State Management
    // Form input states for user credentials
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            // MARK: - Header Section
            Text("Sign Up or Sign In")
                .font(.largeTitle)
                .padding(.bottom, 30)
            
            // - Authentication Form
            VStack(spacing: 20) {
                // User input fields for authentication
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // MARK: - Authentication Buttons
                VStack(spacing: 12) {
                    // Sign Up button with async authentication call
                    Button("Sign Up") {
                        Task {
                            await userViewModel.signUp(with: email, password: password)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Sign In button with async authentication call
                    Button("Sign In") {
                        Task {
                            await userViewModel.signIn(with: email, password: password)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            //- Dad Joke Section
            // Displays a random joke while users are on the sign-up page
            Group {
                if jokeViewModel.isLoading {
                    ProgressView()
                } else if !jokeViewModel.currentJoke.isEmpty {
                    Text(jokeViewModel.currentJoke)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                } else {
                    Text("Loading joke...")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        // Fetch a random joke when the view appears
        .onAppear {
            jokeViewModel.fetchRandomJoke()
        }
    }
}
