import SwiftUI
import UIKit

struct FireworkView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        emitter.emitterShape = .point
        
        let particle = CAEmitterCell()
        particle.birthRate = 30
        particle.lifetime = 5.0
        particle.velocity = 200
        particle.velocityRange = 50
        particle.emissionRange = .pi * 2
        particle.scale = 0.1
        particle.scaleRange = 0.2
        particle.color = randomCGColor()
        particle.contents = UIImage(systemName: "sparkle")?.cgImage
        
        emitter.emitterCells = [particle]
        view.layer.addSublayer(emitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitter.birthRate = 0
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func randomCGColor() -> CGColor {
        CGColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
}
