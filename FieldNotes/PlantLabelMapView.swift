import SwiftUI
import MapKit

struct PlantLabelMapView: View {
    // View Model for handling plant labeling and location logic
    @StateObject private var viewModel = PlantLabelViewModel()
    
    // State management for plant labeling interface
    @State private var newPlantName: String = ""
    @State private var showPlantLabelPrompt = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        // GeometryReader provides size information for coordinate conversion
        GeometryReader { geometry in
            ZStack {
                // Interactive map display with plant markers
                Map(coordinateRegion: $viewModel.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    annotationItems: viewModel.labeledPlants) { plant in
                    // Custom annotation view for each labeled plant
                    MapAnnotation(coordinate: plant.coordinate) {
                        VStack {
                            // Plant marker icon
                            Image(systemName: "leaf.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                            // Plant name label
                            Text(plant.name)
                                .font(.caption)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(4)
                        }
                    }
                }
                .ignoresSafeArea()
                // Handle map taps for adding new plant labels
                .onTapGesture { location in
                    let coordinate = viewModel.convertToCoordinate(
                        tapLocation: location,
                        mapSize: geometry.size,
                        region: viewModel.region
                    )
                    selectedCoordinate = coordinate
                    showPlantLabelPrompt = true
                }
                
                // Loading indicator while getting location
                if viewModel.isLoading {
                    ProgressView("Loading location...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
        }
        // Navigation and title configuration
        .navigationTitle("Label Found Plants")
        .navigationBarTitleDisplayMode(.inline)
        
        // Alert for plant labeling input
        .alert("Label the Plant", isPresented: $showPlantLabelPrompt) {
            TextField("Plant Name", text: $newPlantName)
            Button("Add") {
                if let coordinate = selectedCoordinate {
                    viewModel.addLabeledPlant(name: newPlantName, coordinate: coordinate)
                    print("Added plant at: \(coordinate.latitude), \(coordinate.longitude)")
                }
                newPlantName = ""
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Enter a name for this plant")
        }
        
        // Initialize location services when view appears
        .onAppear {
            viewModel.getLocation()
        }
    }
}
