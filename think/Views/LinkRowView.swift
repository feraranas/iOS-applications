//
//  LinkRowView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI
#if DEBUG
import Inject
#endif

struct LinkRowView: View {
    let link: Link
    @State private var isHoveringFavorite = false
    
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(">> ")
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                        Text(link.name)
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Text("   ")
                        Text(link.url)
                            .font(.custom("Monaco", size: 12))
                            .foregroundColor(.green.opacity(0.8))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Star/Favorite Button
                Button(action: {
                    // TODO: Add favorite functionality
                }) {
                    Image(systemName: link.isFavorite ? "star.fill": "star")
                        .foregroundColor(.green)
                        .font(.custom("Monaco", size: 14))
                }
                .accessibilityLabel("Toggle favorite status")
                .opacity(0.8)
                .buttonStyle(.plain)
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 8.0))
                .opacity(isHoveringFavorite ? 0.8 : 1.0)
                .onHover(perform: { hovering in
                    self.isHoveringFavorite = hovering
                    if hovering {
                        NSCursor.pointingHand.set()
                    } else {
                        NSCursor.arrow.set()
                    }
                })
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("[\(link.category)]")
                        .font(.custom("Monaco", size: 12))
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Rectangle()
                                .fill(Color.black)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.green, lineWidth: 1)
                                )
                        )
                        .foregroundColor(.green)
                    
                    Text(dateFormatter.string(from: link.date))
                        .font(.custom("Monaco", size: 10))
                        .foregroundColor(.green.opacity(0.6))
                }
            }
            
            if !link.description.isEmpty {
                HStack {
                    Text("   # ")
                        .font(.custom("Monaco", size: 12))
                        .foregroundColor(.green.opacity(0.7))
                    Text(link.description)
                        .font(.custom("Monaco", size: 12))
                        .foregroundColor(.green.opacity(0.7))
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        #if DEBUG
        .enableInjection()
        #endif
    }
}

#Preview {
    LinkRowView(link: Link(
        url: "https://www.apple.com",
        name: "Apple",
        category: "Technology",
        description: "Apple's official website with products and services",
        isFavorite: true
    ))
    .padding()
}
