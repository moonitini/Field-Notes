//
//  Quote.swift
//  FieldNotes
//
//  Created by Bona Suh on 12/11/24.
//

import Foundation

// Model for decoding API response for the quotes in the photo picker page
struct Quote: Codable {
    let quote: String
    let author: String
}
