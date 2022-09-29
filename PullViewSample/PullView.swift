//
//  PullView.swift
//  PullViewSample
//
//  Created by Uwe Tilemann on 25.09.22.
//

import Foundation
import SwiftUI

struct PullOverView<Content> : View where Content : View {
    @Binding var minHeight: CGFloat
    let paddingTop: CGFloat
    let onExpand: () -> Void
    let onCollapse: () -> Void
    let content: () -> Content

    init(minHeight: Binding<CGFloat>, paddingTop: CGFloat = 16, onExpand: @escaping () -> Void, onCollapse: @escaping () -> Void, content: @escaping () -> Content) {
        self._minHeight = minHeight
        self.paddingTop = paddingTop
        self.onExpand = onExpand
        self.onCollapse = onCollapse
        self.content = content
    }
    
    public var body: some View {
        ModifiedContent(content: self.content(), modifier: PullView(minHeight: $minHeight, paddingTop: paddingTop, onExpand: onExpand, onCollapse: onCollapse))
    }
}

struct CardShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bl = CGPoint(x: rect.minX, y: rect.maxY)
        let br = CGPoint(x: rect.maxX, y: rect.maxY)
        let trs = CGPoint(x: rect.maxX, y: rect.minY + radius)
        let trc = CGPoint(x: rect.maxX - radius, y: rect.minY + radius)
        let tls = CGPoint(x: rect.minX + radius, y: rect.minY)
        let tlc = CGPoint(x: rect.minX + radius, y: rect.minY + radius)
        
        path.move(to: bl)
        path.addLine(to: br)
        
        path.addLine(to: trs)
        path.addRelativeArc(
            center: trc,
            radius: radius,
            startAngle: Angle.degrees(0),
            delta: Angle.degrees(-90))
        
        path.addLine(to: tls)
        path.addRelativeArc(
            center: tlc,
            radius: radius,
            startAngle: Angle.degrees(-90),
            delta: Angle.degrees(-90))
        
        return path
    }
}

struct PullView: ViewModifier {
    @Binding var minHeight: CGFloat
    let paddingTop: CGFloat
    let onExpand: () -> Void
    let onCollapse: () -> Void

    @State private var dragging = false
    @GestureState private var dragTracker = CGSize.zero
    @State private var position: CGFloat = 0
    @State private var minYPosition: CGFloat = 0
    
    func setupMinHeight(geom: GeometryProxy) {
        minYPosition = geom.size.height - minHeight
        position = minYPosition
    }
    func body(content: Content) -> some View {
        GeometryReader { geom in
            ZStack(alignment: .top) {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 60, height: 6.0)
                        .foregroundColor(.secondary)
                        .padding(10)
                    content.padding(.top, 16)
                }
                .frame(minWidth: UIScreen.main.bounds.width)
                .scaleEffect(x: 1, y: 1, anchor: .center)
                .background(Color(white:0.9, opacity: 1))
//                .background(.thickMaterial)
                .clipShape( CardShape(radius: 16) )
            }
            .onChange(of: minHeight) { newHeight in
                setupMinHeight(geom: geom)
            }
            .onAppear {
                setupMinHeight(geom: geom)
            }
            .frame(maxHeight: geom.size.height - (position + self.dragTracker.height))
            .offset(y:  max(0, position + self.dragTracker.height))
            .animation(.easeInOut(duration: 0.2), value: position)
            .animation(Animation.interpolatingSpring(stiffness: 250.0, damping: 40.0, initialVelocity: 5.0), value: dragging)
            .gesture(DragGesture()
                .updating($dragTracker) { drag, state, transaction in state = drag.translation }
                .onChanged {_ in  dragging = true }
                .onEnded(onDragEnded))
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        dragging = false

        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        //can also calculate drag offset to make it more rigid to shrink and expand
        if dragDirection > 0 {
            position = minYPosition
            onCollapse()
        } else {
            position = paddingTop
            onExpand()
        }
    }
}
