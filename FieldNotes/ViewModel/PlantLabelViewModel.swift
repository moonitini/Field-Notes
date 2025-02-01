import SwiftUI
import MapKit
import CoreLocation

// View model that handles map interactions, location services, and plant labeling functionality
class PlantLabelViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
   // Published Properties
   // Loading state for location services
   @Published var isLoading = false
   // Array of plants that have been labeled on the map
   @Published var labeledPlants: [LabeledPlant] = []
   // Current visible region on the map, centered on Los Angeles by default
   @Published var region = MKCoordinateRegion(
       center: CLLocationCoordinate2D(latitude: 34.0219482, longitude: -118.2845617),
       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
   )
   
   // Location Services
   // Location manager for handling device location updates
   let locationManager = CLLocationManager()

   // Initialize the view model and set up location services
   override init() {
       super.init()
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.distanceFilter = 10.0
       requestLocationPermission()
   }
   
   // Coordinate Conversion
   // Converts a tap location on the screen to map coordinates
   // - Parameters:
   //   - tapLocation: Point where user tapped on screen
   //   - mapSize: Size of the map view
   //   - region: Current visible region on map
   // - Returns: Geographic coordinates for the tap location
   func convertToCoordinate(tapLocation: CGPoint, mapSize: CGSize, region: MKCoordinateRegion) -> CLLocationCoordinate2D {
       // Get the span of the visible map region
       let latitudeDelta = region.span.latitudeDelta
       let longitudeDelta = region.span.longitudeDelta
       
       // Calculate the offset from center as a percentage of the map size
       let xPercentage = Double(tapLocation.x / mapSize.width)
       let yPercentage = Double(tapLocation.y / mapSize.height)
       
       // Calculate the actual coordinate offsets
       let latitudeOffset = latitudeDelta * (0.5 - yPercentage)
       let longitudeOffset = longitudeDelta * (xPercentage - 0.5)
       
       // Calculate the final coordinates
       let latitude = region.center.latitude + latitudeOffset
       let longitude = region.center.longitude + longitudeOffset
       
       return CLLocationCoordinate2D(
           latitude: latitude,
           longitude: longitude
       )
   }

   //  Location Authorization
   // Request permission to access device location
   func requestLocationPermission() {
       locationManager.requestWhenInUseAuthorization()
   }
   
   // Start updating device location
   func getLocation() {
       isLoading = true
       locationManager.startUpdatingLocation()
   }

   //CLLocationManagerDelegate Methods
   // Handle changes in location authorization status
   func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
       let status = manager.authorizationStatus
       
       if status == .authorizedWhenInUse || status == .authorizedAlways {
           manager.startUpdatingLocation()
       }
   }
   
   // Handle successful location updates
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       guard let location = locations.first else { return }
       
       DispatchQueue.main.async { [weak self] in
           guard let self = self else { return }
           self.region = MKCoordinateRegion(
               center: location.coordinate,
               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
           )
           self.isLoading = false
           manager.stopUpdatingLocation()
       }
   }
   
   // Handle location update failures
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Failed to get location: \(error.localizedDescription)")
       DispatchQueue.main.async {
           self.isLoading = false
       }
   }
   
   //Plant Management
   // Add a new labeled plant to the map
   // - Parameters:
   //   - name: Name of the plant
   //   - coordinate: Location where the plant was found
   func addLabeledPlant(name: String, coordinate: CLLocationCoordinate2D) {
       let newPlant = LabeledPlant(name: name, coordinate: coordinate)
       DispatchQueue.main.async {
           self.labeledPlants.append(newPlant)
           print("Plant added: \(name) at \(coordinate.latitude), \(coordinate.longitude)")
           print("Total plants: \(self.labeledPlants.count)")
       }
   }
}
