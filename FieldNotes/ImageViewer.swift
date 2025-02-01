import SwiftUI

//Image Viewer
// Full-screen view for displaying selected images
struct ImageViewer: View {
    // MARK: - Properties
    // Environment variable to handle view dismissal
    @Environment(\.presentationMode) var presentationMode
    // Image to be displayed
    let image: UIImage
    
    var body: some View {
        NavigationView {
            ZStack {
                // Viewer Background
                // Dark background for better image contrast
                Color.black.opacity(0.95)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    //  Image Display
                    // Scaled image with subtle decoration
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .white.opacity(0.1), radius: 8)
                        .padding()
                    
                    // Optional caption
                    Text("Field Notes Collection")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }
            //  Navigation Controls
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
            )
        }
        // Gesture Handling
        // Allows dismissal by tapping anywhere
        .gesture(
            TapGesture()
                .onEnded { _ in
                    presentationMode.wrappedValue.dismiss()
                }
        )
    }
}
