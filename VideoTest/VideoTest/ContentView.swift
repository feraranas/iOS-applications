//
//  ContentView.swift
//  VideoTest
//
//  Created by Fernando Arana on 30/01/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            LoopingPlayer()
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
