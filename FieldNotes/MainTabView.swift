import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: PhotoLibraryViewModel
    @StateObject var plantLabelViewModel = PlantLabelViewModel()
    
    var body: some View {
        TabView {
            // First Tab: Upload Image Section
            SelectImageView()
                .tabItem {
                    Label("Upload Image", systemImage: "photo.on.rectangle.angled")
                }
            
            // Second Tab: Gallery Section
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.fill.on.rectangle.fill")
                }
            
            // Third Tab: Map Section
            PlantLabelMapView()
                .environmentObject(plantLabelViewModel)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            // Fourth Tab: Diary Section
            DiaryPageView()
                .tabItem {
                    Label("Diary", systemImage: "book.fill")
                }
        }
    }
}
