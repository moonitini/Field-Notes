import Foundation
import Photos
import SwiftUI

class PhotoLibraryViewModel: ObservableObject {
    // Published properties for UI state management
    @Published var isImagePickerShown: Bool = false     // Controls image picker presentation
    @Published var image: UIImage? = nil                // Currently selected image
    @Published var photoAssets: [UIImage] = []          // Collection of all selected images
    @Published var isAuthorized: Bool = false           // Photo library authorization status
    
    // Request access to device photo library
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            // Update authorization status on main thread
            DispatchQueue.main.async {
                self?.isAuthorized = (status == .authorized || status == .limited)
            }
        }
    }
    
    // Add new photo to the collection
    func addPhoto(_ image: UIImage) {
        photoAssets.append(image)
    }
}
