//
//  ContentView.swift
//  Catholic Bible
//
//  Created by Anoop Jose on 17/05/2024.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var glareOffset: CGFloat = -200

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.brown.withAlphaComponent(0.4))
                    .ignoresSafeArea()
                GeometryReader { geometry in
                    let cardWidth = geometry.size.width * 0.9 // Adjust card width to 90% of the device width
                    ScrollView(.vertical) {
                        VStack {
                            NavigationLink(destination: BibleView()) {
                                cardView(title: "Verse of the Day", glareColor: .blue, width: cardWidth)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding()

                            NavigationLink(destination: BibleView()) {
                                cardView(title: "CPDV Bible", glareColor: .orange, width: cardWidth)
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding()
                        }
                    }
                }
                .navigationTitle("Catholic Bible")
            }
        }
    }
    
    private func cardView(title: String, glareColor: Color, width: CGFloat) -> some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.brown)
                .frame(width: width, height: 200)
                .shadow(radius: 10)
            
            // Text on the card
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .padding()
            
            // Glare effect
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [glareColor.opacity(1.0), Color.clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: width, height: 200)
                .rotationEffect(.degrees(20))
                .offset(x: glareOffset)
                .blendMode(.overlay)
                .mask(
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: width, height: 200)
                )
                .animation(
                    Animation.linear(duration: 2)
                        .repeatForever(autoreverses: true), value: glareOffset
                )
        }
        .parallaxMotion()
        .onAppear {
            withAnimation {
                glareOffset = 200
            }
        }
    }
}

// ParallaxMotionModifier
struct ParallaxMotionModifier: ViewModifier {
    @State private var offset: CGSize = .zero
    private let motionManager = CMMotionManager()

    func body(content: Content) -> some View {
        content
            .offset(x: offset.width, y: offset.height)
            .onAppear {
                startMotionUpdates()
            }
            .onDisappear {
                motionManager.stopDeviceMotionUpdates()
            }
    }

    private func startMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion, error == nil else { return }
            let attitude = motion.attitude
            let roll = attitude.roll
            let pitch = attitude.pitch

            withAnimation(.easeOut(duration: 0.1)) {
                self.offset = CGSize(width: roll * 20, height: pitch * 20)
            }
        }
    }
}

extension View {
    func parallaxMotion() -> some View {
        self.modifier(ParallaxMotionModifier())
    }
}

// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
