//
//  DiaryEntry.swift
//  FieldNotes
//
//  Created by Bona Suh on 12/10/24.
//

import Foundation

//diary entry for foraging diary section
struct DiaryEntry: Identifiable, Decodable {
    let id: UUID
    let title: String
    let body: String
    let date: String
}
