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
            // Terminal background
            TerminalBackground()
            
            NavigationView {
                if showingAddLink {
                    AddLinkView(linkStore: linkStore) {
                        showingAddLink = false
                    }
                } else {
                    VStack {
                        if linkStore.filteredLinks.isEmpty {
                            VStack(spacing: 16) {
                                Text("┌─────────────────┐")
                                    .font(.custom("Monaco", size: 16))
                                    .foregroundColor(.green)
                                Text("│   NO_LINKS_FOUND   │")
                                    .font(.custom("Monaco", size: 16))
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                                Text("└─────────────────┘")
                                    .font(.custom("Monaco", size: 16))
                                    .foregroundColor(.green)
                                Text(linkStore.searchText.isEmpty ? "# Execute add-link command" : "# No matches for search query")
                                    .font(.custom("Monaco", size: 12))
                                    .foregroundColor(.green.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(linkStore.filteredLinks) { link in
                                        LinkRowView(link: link)
                                            .terminalCard()
                                            .onTapGesture {
                                                if let url = URL(string: link.url) {
                                                    NSWorkspace.shared.open(url)
                                                }
                                            }
                                            .contextMenu {
                                                Button("rm -rf link", role: .destructive) {
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
