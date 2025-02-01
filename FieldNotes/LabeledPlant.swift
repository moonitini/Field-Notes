//
//  FieldNotes
//
//  Created by Bona Suh on 12/11/24.
//

import Foundation
import CoreLocation

//labeled plant for plant markers on the map
struct LabeledPlant: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
