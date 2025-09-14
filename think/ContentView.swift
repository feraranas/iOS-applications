//
//  ContentView.swift
//  think
//
//  Created by Fernando Arana on 13/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var linkStore = LinkStore()
    
    var body: some View {
        LinksListView(linkStore: linkStore)
    }
}

#Preview {
    ContentView()
}
