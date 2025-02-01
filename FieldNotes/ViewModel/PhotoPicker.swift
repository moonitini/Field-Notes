import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
   // View model reference for handling selected photos
   @ObservedObject var viewModel: PhotoLibraryViewModel
   
   // Create and configure the photo picker view controller
   func makeUIViewController(context: Context) -> PHPickerViewController {
       var config = PHPickerConfiguration()
       config.filter = .images           // Restrict to image selection only
       config.selectionLimit = 0         // Allow multiple image selection
       let picker = PHPickerViewController(configuration: config)
       picker.delegate = context.coordinator
       return picker
   }
   
   func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
   
   // Create coordinator to handle picker delegate callbacks
   func makeCoordinator() -> Coordinator {
       Coordinator(self)
   }
   
   // Coordinator class handles photo picker interaction
   class Coordinator: NSObject, PHPickerViewControllerDelegate {
       let parent: PhotoPicker
       
       init(_ parent: PhotoPicker) {
           self.parent = parent
       }
       
       // Handle photo selection completion
       func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           picker.dismiss(animated: true)
           
           // Process each selected photo
           for result in results {
               let provider = result.itemProvider
               if provider.canLoadObject(ofClass: UIImage.self) {
                   // Load image asynchronously
                   provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                       guard let uiImage = image as? UIImage else { return }
                       // Update view model on main thread
                       DispatchQueue.main.async {
                           self?.parent.viewModel.addPhoto(uiImage)
                       }
                   }
               }
           }
       }
   }
}
