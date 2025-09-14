//
//  Link.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import Foundation

struct Link: Identifiable, Codable {
    let id: UUID
    let date: Date
    let url: String
    let name: String
    let category: String
    let description: String
    var isFavorite: Bool
    
    init(url: String, name: String, category: String, description: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.date = Date()
        self.url = url
        self.name = name
        self.category = category
        self.description = description
        self.isFavorite = isFavorite
    }
}
