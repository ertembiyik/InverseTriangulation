//
//  ContentView.swift
//  InverseTriangulation
//
//  Created by Ertem Biyik on 04.06.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
          MetalView()
            .border(Color.black, width: 2)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
