//
//  LinksListView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI
#if DEBUG
import Inject
#endif

struct LinksListView: View {
    @ObservedObject var linkStore: LinkStore
    @State private var showingAddLink = false
    
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    var body: some View {
        ZStack {
            // Liquid glass background
            LiquidGlassBackground()
            
            NavigationView {
                if showingAddLink {
                    AddLinkView(linkStore: linkStore) {
                        showingAddLink = false
                    }
                } else {
                    VStack {
                        if linkStore.filteredLinks.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "link")
                                    .font(.system(size: 48))
                                    .foregroundColor(.secondary)
                                Text("No Links")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Text(linkStore.searchText.isEmpty ? "Add your first link to get started" : "No links match your search")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(linkStore.filteredLinks) { link in
                                        LinkRowView(link: link)
                                            .glassCard(cornerRadius: 12, opacity: 0.1)
                                            .onTapGesture {
                                                if let url = URL(string: link.url) {
                                                    NSWorkspace.shared.open(url)
                                                }
                                            }
                                            .contextMenu {
                                                Button("Delete", role: .destructive) {
                                                    linkStore.deleteLink(link)
                                                }
                                            }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .navigationTitle("Links")
                    .searchable(text: $linkStore.searchText, prompt: "Search links...")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                showingAddLink = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
        }
        #if DEBUG
        .enableInjection()
        #endif
    }
}

#Preview {
    LinksListView(linkStore: LinkStore())
}
