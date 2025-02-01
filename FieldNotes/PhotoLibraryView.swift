import SwiftUI
import PhotosUI

struct PhotoLibraryView: View {
    @StateObject private var viewModel = PhotoLibraryViewModel()
    @State private var showPhotoPicker = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isAuthorized {
                    // Gallery of selected photos
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(viewModel.photoAssets, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            }
                        }
                    }
                } else {
                    // Request access if not authorized
                    VStack {
                        Text("Photo library access is required.")
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Grant Access") {
                            viewModel.requestPhotoLibraryAccess()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                // Button to add photos
                Button(action: {
                    showPhotoPicker = true
                }) {
                    Text("Add Photos")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
                .sheet(isPresented: $showPhotoPicker) {
                    PhotoPicker(viewModel: viewModel)
                }
            }
            .padding()
            .navigationTitle("Gallery")
        }
        .onAppear {
            viewModel.requestPhotoLibraryAccess()
        }
    }
}
