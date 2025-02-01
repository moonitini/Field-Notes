//
//  DiaryPageView.swift
//  FieldNotes
//
//  Created by Bona Suh on 12/10/24.
//

import SwiftUI

struct DiaryPageView: View {
    @State private var diaryEntries: [DiaryEntry] = [] // Use a struct for diary entries
    @State private var newTitle: String = ""
    @State private var newBody: String = ""
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationView {
            VStack {
                // List of Diary Entries
                List {
                    ForEach(diaryEntries, id: \.id) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.title)
                                .font(.headline)
                            Text(entry.date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(entry.body)
                                .font(.body)
                                .padding(.top, 4)
                        }
                        .padding(.vertical, 5)
                    }
                }

                // New Entry Form
                VStack(alignment: .leading) {
                    TextField("Title :)", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)

                    TextEditor(text: $newBody)
                        .frame(minHeight: 100)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .padding()

                // Add Button
                HStack {
                    Spacer()
                    Button(action: {
                        guard !newTitle.isEmpty, !newBody.isEmpty else { return }
                        let newEntry = DiaryEntry(id: UUID(), title: newTitle, body: newBody, date: currentDate)
                        diaryEntries.append(newEntry)
                        newTitle = ""
                        newBody = ""
                    }) {
                        Text("Add Entry")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.bottom)
            }
            .navigationTitle("Foraging Diary")
        }
    }
}

