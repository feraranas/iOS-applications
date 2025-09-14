//
//  Link.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import Foundation

struct Link: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let url: String
    let name: String
    let category: String
    let description: String
    
    init(url: String, name: String, category: String, description: String) {
        self.date = Date()
        self.url = url
        self.name = name
        self.category = category
        self.description = description
    }
}
