//
//  LinkStore.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import Foundation
import SwiftUI

@MainActor
class LinkStore: ObservableObject {
    @Published var links: [Link] = []
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let linksKey = "SavedLinks"
    
    init() {
        loadLinks()
    }
    
    var filteredLinks: [Link] {
        if searchText.isEmpty {
            return links.sorted { $0.date > $1.date }
        } else {
            return links.filter { link in
                link.name.localizedCaseInsensitiveContains(searchText) ||
                link.url.localizedCaseInsensitiveContains(searchText) ||
                link.category.localizedCaseInsensitiveContains(searchText) ||
                link.description.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.date > $1.date }
        }
    }
    
    func addLink(url: String, name: String, category: String, description: String) {
        let newLink = Link(url: url, name: name, category: category, description: description)
        links.append(newLink)
        saveLinks()
    }
    
    func deleteLink(_ link: Link) {
        links.removeAll { $0.id == link.id }
        saveLinks()
    }
    
    private func saveLinks() {
        if let encoded = try? JSONEncoder().encode(links) {
            userDefaults.set(encoded, forKey: linksKey)
        }
    }
    
    private func loadLinks() {
        if let data = userDefaults.data(forKey: linksKey),
           let decodedLinks = try? JSONDecoder().decode([Link].self, from: data) {
            links = decodedLinks
        }
    }
}
