//
//  ContentView.swift
//  think
//
//  Created by Fernando Arana on 13/09/25.
//

import SwiftUI
#if DEBUG
import Inject
#endif

// MARK: - Terminal Components
struct TerminalBackground: View {
    var body: some View {
        Color.black
            .ignoresSafeArea()
    }
}

struct TerminalCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(Color.black)
                    .overlay(
                        Rectangle()
                            .stroke(Color.green, lineWidth: 1)
                    )
            )
    }
}

struct TerminalButton: ViewModifier {
    var isPressed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(isPressed ? Color.green.opacity(0.3) : Color.black)
                    .overlay(
                        Rectangle()
                            .stroke(Color.green, lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
    }
}

struct TerminalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Monaco", size: 14))
            .foregroundColor(.green)
            .padding(12)
            .background(Color.black)
            .overlay(
                Rectangle()
                   
                    .stroke(Color.green, lineWidth: 1)
            )
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.title)
            .foregroundColor(Color(red: 107.0 / 255.0, green: 107.0 / 255.0, blue: 107.0 / 255.0))
            .padding(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 10))
            .frame(height: 48)
            .textFieldStyle(.plain)
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(10.0)
    }
}

extension View {
    func terminalCard() -> some View {
        modifier(TerminalCard())
    }
    
    func terminalButton(isPressed: Bool = false) -> some View {
        modifier(TerminalButton(isPressed: isPressed))
    }
}

struct ContentView: View {
    @StateObject private var linkStore = LinkStore()
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAddButtonPressed = false
    
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    var body: some View {
        ZStack {
            // Terminal background
            TerminalBackground()
            
            VStack(spacing: 20) {
                // Terminal header
                HStack {
                    Text("$ link-manager")
                        .font(.custom("Monaco", size: 16))
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                    Spacer()
                    Text("◉ ◉ ◉")
                        .font(.custom("Monaco", size: 12))
                        .foregroundColor(.green)
                }
                .padding(.horizontal)
                
                // Add Link Form Section
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .center, spacing: 16) {
                        Text("> URL:")
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                        TextField("", text: $url)
                            .textFieldStyle(ModernTextFieldStyle())
                            .frame(maxWidth: 200)
                        
                        Text("> NAME:")
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                        TextField("", text: $name)
                            .textFieldStyle(ModernTextFieldStyle())
                            .frame(maxWidth: 150)
                        
                        Text("> CATEGORY:")
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                        TextField("", text: $category)
                            .textFieldStyle(ModernTextFieldStyle())
                            .frame(maxWidth: 120)
                        
                        Text("> DESCRIPTION:")
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                        TextField("", text: $description)
                            .textFieldStyle(ModernTextFieldStyle())
                            .frame(maxWidth: 150)
                        
                        Button(action: {
                            saveLink()
                        }) {
                            VStack(spacing: 2) {
                                Text("[ADD]")
                                    .font(.custom("Monaco", size: 12))
                                    .fontWeight(.bold)
                                Text("LINK")
                                    .font(.custom("Monaco", size: 10))
                            }
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .frame(maxWidth: 150, maxHeight: 150)
                        }
                        .terminalButton(isPressed: isAddButtonPressed)
                        .disabled(!isValidInput)
                        .opacity(isValidInput ? 1.0 : 0.6)
                        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isAddButtonPressed = pressing
                            }
                        }, perform: {})
                        
                        Spacer()
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .terminalCard()
                
                // Links List Section
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("$ search:")
                            .font(.custom("Monaco", size: 14))
                            .foregroundColor(.green)
                        TextField("", text: $linkStore.searchText)
                            .textFieldStyle(ModernTextFieldStyle())
                            .frame(maxWidth: 250)
                        
                        Spacer()
                    }
                    .padding()
                    
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
                            Text(linkStore.searchText.isEmpty ? "# Execute ADD_LINK command above" : "# No matches for search query")
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
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(minWidth: 400)
                .terminalCard()
            }
            .padding()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        #if DEBUG
        .enableInjection()
        #endif
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
        
        // Clear the form after successful save
        clearForm()
    }
    
    private func clearForm() {
        url = ""
        name = ""
        category = ""
        description = ""
    }
    
    private func isValidURL(_ string: String) -> Bool {
        if let url = URL(string: string) {
            return url.scheme != nil && url.host != nil
        }
        return false
    }
}

#Preview {
    ContentView()
}
