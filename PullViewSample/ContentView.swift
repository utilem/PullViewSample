//
//  ContentView.swift
//  PullViewSample
//
//  Created by Uwe Tilemann on 25.09.22.
//

import SwiftUI

struct OrderView: View {
    var body: some View {
        Text("Order")
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            PullContentView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            OrderView()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
