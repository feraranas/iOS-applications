//
//  AddLinkView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI

struct AddLinkView: View {
    @ObservedObject var linkStore: LinkStore
    let onDismiss: () -> Void
    
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Liquid glass background
            LiquidGlassBackground()
            
            NavigationView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Link Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("URL")
                                .font(.headline)
                                .foregroundColor(.primary)
                            TextField("Enter URL", text: $url)
                                .textFieldStyle(GlassTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.headline)
                                .foregroundColor(.primary)
                            TextField("Enter link name", text: $name)
                                .textFieldStyle(GlassTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(.primary)
                            TextField("Enter category", text: $category)
                                .textFieldStyle(GlassTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.primary)
                            TextField("Enter description", text: $description, axis: .vertical)
                                .textFieldStyle(GlassTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .glassCard(cornerRadius: 20, opacity: 0.15)
                .padding()
                .navigationTitle("Add Link")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            onDismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveLink()
                        }
                        .disabled(!isValidInput)
                    }
                }
                .alert("Error", isPresented: $showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    private var isValidInput: Bool {
        !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveLink() {
        let trimmedURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Basic URL validation
        if !isValidURL(trimmedURL) {
            alertMessage = "Please enter a valid URL"
            showingAlert = true
            return
        }
        
        linkStore.addLink(
            url: trimmedURL,
            name: trimmedName,
            category: trimmedCategory,
            description: trimmedDescription
        )
        
        onDismiss()
    }
    
    private func isValidURL(_ string: String) -> Bool {
        if let url = URL(string: string) {
            return url.scheme != nil && url.host != nil
        }
        return false
    }
}

#Preview {
    AddLinkView(linkStore: LinkStore()) { }
}
