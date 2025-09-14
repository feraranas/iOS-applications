//
//  LinksListView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI

struct LinksListView: View {
    @ObservedObject var linkStore: LinkStore
    @State private var showingAddLink = false
    
    var body: some View {
        NavigationView {
            VStack {
                if linkStore.filteredLinks.isEmpty {
                    ContentUnavailableView(
                        "No Links",
                        systemImage: "link",
                        description: Text(linkStore.searchText.isEmpty ? "Add your first link to get started" : "No links match your search")
                    )
                } else {
                    List {
                        ForEach(linkStore.filteredLinks) { link in
                            LinkRowView(link: link)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete", role: .destructive) {
                                        linkStore.deleteLink(link)
                                    }
                                }
                                .onTapGesture {
                                    if let url = URL(string: link.url) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Links")
            .searchable(text: $linkStore.searchText, prompt: "Search links...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddLink = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddLink) {
                AddLinkView(linkStore: linkStore)
            }
        }
    }
}

#Preview {
    LinksListView(linkStore: LinkStore())
}
