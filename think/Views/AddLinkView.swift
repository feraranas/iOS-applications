//
//  AddLinkView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI

struct AddLinkView: View {
    @ObservedObject var linkStore: LinkStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Link Details")) {
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    TextField("Name", text: $name)
                    
                    TextField("Category", text: $category)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Link")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
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
        
        dismiss()
    }
    
    private func isValidURL(_ string: String) -> Bool {
        if let url = URL(string: string) {
            return url.scheme != nil && url.host != nil
        }
        return false
    }
}

#Preview {
    AddLinkView(linkStore: LinkStore())
}
