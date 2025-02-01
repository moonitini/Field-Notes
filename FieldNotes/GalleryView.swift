import SwiftUI

// Gallery View
// Main view for displaying the photo gallery with a nature-themed design
struct GalleryView: View {
    // MARK: - Properties
    // View model containing photo data and business logic
    @EnvironmentObject var viewModel: PhotoLibraryViewModel
    // Currently selected image for full-screen viewing
    @State private var selectedImage: IdentifiableImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                // Creates a top-to-bottom gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.05),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // MARK: - Content
                if viewModel.photoAssets.isEmpty {
                    // MARK: Empty State
                    // Displays when no photos are available
                    VStack(spacing: 20) {
                        // Stacked nature-themed icons
                        VStack(spacing: 12) {
                            // Primary leaf icon
                            Image(systemName: "leaf.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.green.opacity(0.6))
                            
                            // Secondary camera icon
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        .padding(.bottom, 8)
                        
                        // Empty state messaging
                        Text("Nature's Gallery")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.primary.opacity(0.8))
                        
                        Text("Capture and document your findings")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    // Photo Grid
                    // Displays photos in grid layout
                    ScrollView {
                        LazyVGrid(columns: [
                            // Adaptive grid that adjusts based on screen size
                            GridItem(.adaptive(minimum: 150, maximum: 170)),
                        ], spacing: 20) {
                            // Iterate through available photos
                            ForEach(viewModel.photoAssets.indices, id: \.self) { index in
                                let image = viewModel.photoAssets[index]
                                Button(action: {
                                    selectedImage = IdentifiableImage(image: image)
                                }) {
                                    // MARK: Photo Cell
                                    ZStack {
                                        // Card background with shadow
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                                        
                                        // Photo display
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        
                                        // Decorative border
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.green.opacity(0.2), lineWidth: 1)
                                    }
                                    .frame(width: 150, height: 150)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            //Navigation and Models
            .sheet(item: $selectedImage) { identifiableImage in
                ImageViewer(image: identifiableImage.image)
            }
            .navigationTitle("Field Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "leaf")
                        .foregroundColor(.green.opacity(0.6))
                        .font(.system(size: 16))
                }
            }
        }
    }
}
