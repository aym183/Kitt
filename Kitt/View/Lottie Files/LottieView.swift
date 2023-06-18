//
//  LottieView.swift
//  Kitt
//
//  Created by Ayman Ali on 18/06/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: "confetti")
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
