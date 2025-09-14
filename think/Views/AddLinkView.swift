//
//  AddLinkView.swift
//  think
//
//  Created by Fernando Arana on 14/09/25.
//

import SwiftUI
#if DEBUG
import Inject
#endif

struct AddLinkView: View {
    @ObservedObject var linkStore: LinkStore
    let onDismiss: () -> Void
    
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    var body: some View {
        ZStack {
            // Terminal background
            TerminalBackground()
            
            NavigationView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("$ add-link")
                        .font(.custom("Monaco", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.bottom, 10)
                    
                    Text("$ add-link")
                        .font(.custom("Monaco", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("> URL:")
                                .font(.custom("Monaco", size: 14))
                                .foregroundColor(.green)
                            TextField("", text: $url)
                                .textFieldStyle(ModernTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("> NAME:")
                                .font(.custom("Monaco", size: 14))
                                .foregroundColor(.green)
                            TextField("", text: $name)
                                .textFieldStyle(ModernTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("> CATEGORY:")
                                .font(.custom("Monaco", size: 14))
                                .foregroundColor(.green)
                            TextField("", text: $category)
                                .textFieldStyle(ModernTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("> DESCRIPTION:")
                                .font(.custom("Monaco", size: 14))
                                .foregroundColor(.green)
                            TextField("", text: $description, axis: .vertical)
                                .textFieldStyle(ModernTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .terminalCard()
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
        #if DEBUG
        .enableInjection()
        #endif
    }
    
    private var isValidInput: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveLink() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Basic URL validation
        //if !isValidURL(trimmedURL) {
        //    alertMessage = "Please enter a valid URL"
        //    showingAlert = true
        //    return
        //}
        
        linkStore.addLink(
            url: url,
            name: trimmedName,
            category: trimmedCategory,
            description: trimmedDescription
        )
        
        onDismiss()
    }
    
    //private func isValidURL(_ string: String) -> Bool {
    //    if let url = URL(string: string) {
    //        return url.scheme != nil && url.host != nil
    //    }
    //    return false
    //}
}

#Preview {
    AddLinkView(linkStore: LinkStore()) { }
}
