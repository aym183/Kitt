//
//  LottieView.swift
//  Kitt
//
//  Created by Ayman Ali on 18/06/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var speed: CGFloat
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = speed
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
