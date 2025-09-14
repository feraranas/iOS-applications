//
//  thinkApp.swift
//  think
//
//  Created by Fernando Arana on 13/09/25.
//

import SwiftUI

@main
struct thinkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
    }
}
