//
//  ContentView.swift
//  think
//
//  Created by Fernando Arana on 13/09/25.
//

import SwiftUI

// MARK: - Liquid Glass Components
struct LiquidGlassBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.6),
                    Color.purple.opacity(0.4),
                    Color.pink.opacity(0.3),
                    Color.orange.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated liquid blobs
            ZStack {
                // Large blob 1
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.4),
                                Color.cyan.opacity(0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 300
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(
                        x: animate ? -50 : 50,
                        y: animate ? -100 : 100
                    )
                    .blur(radius: 60)
                
                // Large blob 2
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.3),
                                Color.indigo.opacity(0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 250
                        )
                    )
                    .frame(width: 350, height: 350)
                    .offset(
                        x: animate ? 100 : -100,
                        y: animate ? 80 : -80
                    )
                    .blur(radius: 40)
                
                // Medium blob 3
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.pink.opacity(0.3),
                                Color.red.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                    .frame(width: 250, height: 250)
                    .offset(
                        x: animate ? -80 : 80,
                        y: animate ? 120 : -120
                    )
                    .blur(radius: 50)
                
                // Small accent blob
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.4),
                                Color.yellow.opacity(0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .frame(width: 200, height: 200)
                    .offset(
                        x: animate ? 60 : -60,
                        y: animate ? -60 : 60
                    )
                    .blur(radius: 30)
            }
            .animation(
                Animation.easeInOut(duration: 8)
                    .repeatForever(autoreverses: true),
                value: animate
            )
        }
        .onAppear {
            animate = true
        }
    }
}

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 16
    var opacity: Double = 0.1
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(opacity)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct GlassButton: ViewModifier {
    var isPressed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .opacity(isPressed ? 0.8 : 0.6)
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
    }
}

struct GlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .opacity(0.6)
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 16, opacity: Double = 0.1) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, opacity: opacity))
    }
    
    func glassButton(isPressed: Bool = false) -> some View {
        modifier(GlassButton(isPressed: isPressed))
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
    
    var body: some View {
        ZStack {
            // Liquid glass background
            LiquidGlassBackground()
            
            HSplitView {
                // Add Link Form Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Add New Link")
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
                        
                        Button(action: {
                            saveLink()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Link")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .glassButton(isPressed: isAddButtonPressed)
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
                .frame(minWidth: 300, maxWidth: 400)
                .glassCard(cornerRadius: 20, opacity: 0.15)
            
                // Links List Section
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("Search links...", text: $linkStore.searchText)
                            .textFieldStyle(GlassTextFieldStyle())
                            .frame(maxWidth: 250)
                        
                        Spacer()
                    }
                    .padding()
                    
                    if linkStore.filteredLinks.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "link")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("No Links")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Text(linkStore.searchText.isEmpty ? "Add your first link using the form on the left" : "No links match your search")
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
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(minWidth: 400)
                .glassCard(cornerRadius: 20, opacity: 0.1)
            }
            .padding()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
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
