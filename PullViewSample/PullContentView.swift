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
    @Binding var minHeight: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.red)
            HStack(spacing: 20) {
                Button(action: {
                        if minHeight > 100 {
                            minHeight -= 32
                        }
                }) {
                    Image(systemName: "minus")
                        .font(.largeTitle)
                        .foregroundColor(minHeight > 100 ? Color.accentColor : .gray)
                }
                Button(action: {
                        if minHeight < 260 {
                            minHeight += 32
                        }
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(minHeight < 260 ? Color.accentColor : .gray)
                }
           }
        }
    }
}

struct PullContentView: View {
    @State private var minHeight: CGFloat = 100.0
    
    var body: some View {
        ZStack(alignment: .top) {
            ScannerView(minHeight: $minHeight)
            
            PullOverView(
                minHeight: $minHeight,
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

