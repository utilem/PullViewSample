//
//  PullContentView.swift
//  PullViewSample
//
//  Created by Uwe Tilemann on 25.09.22.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("0 Artikel")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
                Text("0,00 €")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 80, height: 44.0)
                    .foregroundColor(.white)
                
                Spacer()
                Button(action: {
                    print("pay")
                })
                {
                    Text("Jetzt bezahlen")
                }
            }
            ScrollView(.vertical) {
                Text("foo")
                    .font(.title)
                Text("bar")
                    .font(.title)
            }
        }.padding([.leading, .trailing], 12)
        
    }
}

struct ScannerView : View {
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
    }
}

struct PullContentView: View {
    var body: some View {
        ZStack(alignment: .top) {
            ScannerView()
            
            PullOverView(
                minHeight: 100,
                paddingTop: 28,
                onExpand: {
                    print("expaned")
                },
                onCollapse: {
                    print("collapse")
                }
            )
            {
                CartView()
            }
        }
    }
}

