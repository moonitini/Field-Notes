import SwiftUI

struct SelectImageView: View {
    // View Model dependencies for photo library and user authentication management
    @EnvironmentObject var appViewModel: PhotoLibraryViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    // State variables for handling inspirational quotes
    @State private var quote: String = "Fetching a quote..."
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header section with app title and logout button
            HStack {
                Text("Field Notes")
                    .font(.title2)
                    .foregroundColor(.primary.opacity(0.8))
                Spacer()
                Button(action: {
                    userViewModel.signOut()
                }) {
                    Image(systemName: "person.crop.circle.badge.xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Spacer()
            
            // Main image section - displays selected image or placeholder
            VStack(spacing: 20) {
                // Conditional rendering based on whether an image is selected
                if let selectedImage = appViewModel.image {
                    // Display selected image with styling
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green.opacity(0.6), lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    // Display placeholder icons when no image is selected
                    VStack {
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green.opacity(0.6))
                        
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.top, 8)
                    }
                }
                
                // Photo selection button
                Button(action: {
                    appViewModel.isImagePickerShown = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 16))
                        Text("Select from Photos")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.green.opacity(0.15))
                    .foregroundColor(.green.opacity(0.8))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            
            Spacer()
            
            // Inspirational quote section
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    // Display quote with styling
                    Text(quote)
                        .font(.system(size: 15))
                        .italic()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(maxWidth: 300)
                    
                    // Refresh quote button
                    Button(action: fetchQuote) {
                        Image(systemName: "leaf.arrow.circlepath")
                            .font(.title3)
                            .foregroundColor(.green.opacity(0.6))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.bottom, 32)
        }
        // Present photo picker sheet when triggered
        .sheet(isPresented: $appViewModel.isImagePickerShown) {
            PhotoPicker(viewModel: appViewModel)
        }
        // Fetch quote when view appears
        .onAppear {
            fetchQuote()
        }
        .background(Color.white)
    }
    
    // Network request function to fetch environmental quotes
    private func fetchQuote() {
        isLoading = true
        let category = "environmental".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "environmental"
        let url = URL(string: "https://api.api-ninjas.com/v1/quotes?category=" + category)!
        
        var request = URLRequest(url: url)
        request.setValue("I0Ku0LhJEoLBDUXzbBzlJQ==20e0f1e56jFLeawI", forHTTPHeaderField: "X-Api-Key")
        
        // Execute network request and handle response
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    print("Error fetching quote: \(error)")
                    self.quote = "Failed to fetch quote. Please try again."
                    return
                }
                
                guard let data = data else {
                    self.quote = "No data received."
                    return
                }
                
                // Parse response and update quote state
                do {
                    if let quotes = try? JSONDecoder().decode([Quote].self, from: data), let firstQuote = quotes.first {
                        self.quote = "\"\(firstQuote.quote)\" - \(firstQuote.author)"
                    } else {
                        self.quote = "Failed to parse quote. Please try again."
                    }
                }
            }
        }
        task.resume()
    }
}
