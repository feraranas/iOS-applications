//
//  LinkRowView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI

struct LinkRowView: View {
    let link: Link
    
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
                    Text(link.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(link.url)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(link.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                    
                    Text(dateFormatter.string(from: link.date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            if !link.description.isEmpty {
                Text(link.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LinkRowView(link: Link(
        url: "https://www.apple.com",
        name: "Apple",
        category: "Technology",
        description: "Apple's official website with products and services"
    ))
    .padding()
}
