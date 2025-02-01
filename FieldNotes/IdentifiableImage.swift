//
//  FieldNotes
//
//  Created by Bona Suh on 12/11/24.
//

import SwiftUI

//image struct for getting image from the gallery 
struct IdentifiableImage: Identifiable {
    let id = UUID() // Unique identifier for the image
    let image: UIImage // The actual UIImage
}
