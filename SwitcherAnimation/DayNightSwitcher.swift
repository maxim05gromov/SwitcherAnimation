//
//  DayNightSwitcher.swift
//  SwitcherAnimation
//
//  Created by Максим Громов on 06.08.2024.
//

import UIKit

class DayNightSwitcher: UIControl {
    var isOn = false // Значение переключателя
    
    private let duration: TimeInterval = 0.5 // Длительность анимации
    
    private let backgroundLayer = CAShapeLayer() // Слой фона
    private let maskLayer = CAShapeLayer() // Слой маски, задающей границы
    
    private let sunLayer = CAShapeLayer() // Слой Солнца или Луны
    private let sunSublayer = CALayer() // Слой с свечением вокруг sunLayer
    
    private let sunSublayers = [(CAShapeLayer(), 194), (CAShapeLayer(), 281), (CAShapeLayer(), 376)] // Слои свечений и их диаметры
    
    private let cloudsLayer1 = CALayer() // Первый слой облаков
    private let clouds1 = [(CAShapeLayer(), 0, 81, 177), (CAShapeLayer(), 278, 6, 73), (CAShapeLayer(), 255, 43, 73), (CAShapeLayer(), 203, 71, 73), (CAShapeLayer(), 165, 83, 73), (CAShapeLayer(), 121, 75, 73)] // Слои для облаков, положение x, y, диаметр
    
    private let cloudsLayer2 = CAShapeLayer() // Второй слой облаков
    private let clouds2 = [(CAShapeLayer(), -6.5, 109, 188), (CAShapeLayer(), 288, 30, 77), (CAShapeLayer(), 264, 69, 77), (CAShapeLayer(), 208, 99, 77), (CAShapeLayer(), 168, 112, 77), (CAShapeLayer(), 121, 103, 77)] // Слои для облаков, положение x, y, диаметр
    
    private let starsLayer1 = CALayer() // Первый слой звезд
    private let stars1 = [(CAShapeLayer(), 43, 32), (CAShapeLayer(), 104, 20), (CAShapeLayer(), 180, 18), (CAShapeLayer(), 108, 66)] // Слои для звезд, положение x, y
    
    private let starsLayer2 = CAShapeLayer() // Второй слой звезд
    private let stars2 = [(CAShapeLayer(), 24, 95), (CAShapeLayer(), 56, 66), (CAShapeLayer(), 149, 104), (CAShapeLayer(), 82, 118)] // Слои для звезд, положение x, y
    
    private let moonLayer = CALayer() // Слой для кратеров луны
    private let moon = [(CAShapeLayer(), 21, 49, 37, 3), (CAShapeLayer(), 46, 23, 23, 2), (CAShapeLayer(), 71, 68, 23, 2)] // Слои для кратеров, x, y, диаметр, радиус тени
    
    private var backgroundInnerShadow = CAShapeLayer() // Нижняя часть тени фона
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure(){
        backgroundLayer.path = UIBezierPath(roundedRect: .init(x: 0, y: 0, width: 343, height: 140), cornerRadius: 70).cgPath
        backgroundLayer.frame = .init(x: 0, y: 0, width: 343, height: 140)
        backgroundLayer.bounds = .init(x: 0, y: 0, width: 343, height: 140)
        
        maskLayer.path = UIBezierPath(roundedRect: .init(x: 0, y: 0, width: 343, height: 140), cornerRadius: 70).cgPath
        backgroundLayer.mask = maskLayer
        backgroundLayer.fillColor = UIColor(named: "DayBackground")!.cgColor
        layer.addSublayer(backgroundLayer)
        
        
        moonLayer.frame = .init(x: 0, y: 0, width: 116, height: 116)
        moonLayer.bounds = .init(x: 0, y: 0, width: 116, height: 116)
        for m in moon{
            let radius = CGFloat(m.3 / 2)
            m.0.path = UIBezierPath(arcCenter: .init(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
            m.0.fillColor = UIColor(named: "Craters")!.cgColor
            m.0.frame = .init(x: m.1, y: m.2, width: m.3, height: m.3)
            m.0.bounds = .init(x: 0, y: 0, width: m.3, height: m.3)
            m.0.addSublayer(m.0.getInnerShadow(x: 1, y: 1, radius: CGFloat(m.4), opacity: 0.5, color: .black))
            m.0.addSublayer(m.0.getInnerShadow(x: -1, y: -1, radius: CGFloat(m.4), opacity: 0.5, color: .white))
            moonLayer.addSublayer(m.0)
        }
        moonLayer.opacity = 0
        
        
        sunLayer.path = UIBezierPath(arcCenter: .init(x: 58, y: 58), radius: 58, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        sunLayer.frame = .init(x: 14, y: 12, width: 116, height: 116)
        sunLayer.bounds = .init(x: 0, y: 0, width: 116, height: 116)
        sunLayer.shadowOffset = .init(width: 2, height: 2)
        sunLayer.shadowRadius = 12
        sunLayer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        sunLayer.shadowOpacity = 0.5
        sunLayer.fillColor = UIColor(named: "Sun")!.cgColor
        sunLayer.addSublayer(moonLayer)
        sunLayer.addSublayer(sunLayer.getInnerShadow(x: 4, y: 6, radius: 4, opacity: 0.5, color: .white))
        sunLayer.addSublayer(sunLayer.getInnerShadow(x: -1, y: -2, radius: 5, opacity: 0.5, color: .black))
        
        
        for s in sunSublayers{
            s.0.path = UIBezierPath(arcCenter: .init(x: 376/2, y: 376/2), radius: CGFloat(s.1/2), startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
            s.0.fillColor = UIColor(named: "SunMoonSublayers")!.cgColor
            sunSublayer.addSublayer(s.0)
        }
        sunSublayer.frame = .init(x: -116, y: -117.5, width: 376, height: 376)
        
        
        
        for c in clouds1{
            let radius = CGFloat(c.3/2)
            c.0.path = UIBezierPath(arcCenter: .init(x: CGFloat(c.1) + radius, y: CGFloat(c.2) + radius), radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
            c.0.fillColor = UIColor(named: "Clouds1")!.cgColor
            cloudsLayer1.addSublayer(c.0)
        }
        for c in clouds2{
            let radius = CGFloat(c.3/2)
            c.0.path = UIBezierPath(arcCenter: .init(x: CGFloat(c.1) + radius, y: CGFloat(c.2) + radius), radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
            c.0.fillColor = UIColor(named: "Clouds2")!.cgColor
            cloudsLayer2.addSublayer(c.0)
        }
        
        
        for s in stars1{
            s.0.path = UIBezierPath(arcCenter: .init(x: s.1-2, y: s.2-2), radius: 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
            s.0.fillColor = UIColor.white.cgColor
            starsLayer1.addSublayer(s.0)
        }
        for s in stars2{
            s.0.path = UIBezierPath(arcCenter: .init(x: s.1-2, y: s.2-2), radius: 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
            s.0.fillColor = UIColor.white.cgColor
            starsLayer2.addSublayer(s.0)
        }
        
        starsLayer1.position = .init(x: -30, y: -70)
        starsLayer2.position = .init(x: -50, y: -120)
        
        
        
        
        backgroundLayer.addSublayer(sunSublayer)
        backgroundLayer.addSublayer(cloudsLayer1)
        backgroundLayer.addSublayer(cloudsLayer2)
        backgroundLayer.addSublayer(starsLayer1)
        backgroundLayer.addSublayer(starsLayer2)
        backgroundLayer.addSublayer(sunLayer)
        
        
        backgroundInnerShadow = backgroundLayer.getInnerShadow(x: -5, y: -5, radius: 4, opacity: 0.5, color: .white)
        backgroundLayer.addSublayer(backgroundInnerShadow)
        backgroundLayer.addSublayer(backgroundLayer.getInnerShadow(x: 5, y: 5, radius: 4, opacity: 0.5, color: .black))
        
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    
    @objc func handleTap(){
        isOn.toggle()
        sendActions(for: .valueChanged)
        updateUI()
    }
    
    
    func updateUI() {
        let backgroundAnimation = CABasicAnimation(keyPath: "fillColor")
        backgroundAnimation.duration = duration
        backgroundAnimation.toValue = isOn ? UIColor(named: "NightBackground")!.cgColor : UIColor(named: "DayBackground")!.cgColor
        backgroundAnimation.fromValue = isOn ? UIColor(named: "DayBackground")!.cgColor : UIColor(named: "NightBackground")!.cgColor
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        backgroundLayer.fillColor = isOn ? UIColor(named: "NightBackground")!.cgColor : UIColor(named: "DayBackground")!.cgColor
        backgroundLayer.add(backgroundAnimation, forKey: "color")
        
        
        let sunMoonAnimationColor = CABasicAnimation(keyPath: "fillColor")
        sunMoonAnimationColor.duration = duration
        sunMoonAnimationColor.fromValue = isOn ? UIColor(named: "Sun")!.cgColor : UIColor(named: "Moon")!.cgColor
        sunMoonAnimationColor.toValue = isOn ? UIColor(named: "Moon")!.cgColor : UIColor(named: "Sun")!.cgColor
        sunMoonAnimationColor.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        sunLayer.fillColor = isOn ? UIColor(named: "Moon")!.cgColor : UIColor(named: "Sun")!.cgColor
        sunLayer.add(sunMoonAnimationColor, forKey: "color")
        
        
        let sunMoonAnimationPosition = CABasicAnimation(keyPath: "position")
        sunMoonAnimationPosition.duration = duration
        sunMoonAnimationPosition.fromValue = isOn ? [74, 70] : [271, 70]
        sunMoonAnimationPosition.toValue = isOn ? [271, 70] : [74, 70]
        sunMoonAnimationPosition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        sunLayer.position = isOn ? .init(x: 271, y: 70) : .init(x: 74, y: 70)
        sunLayer.add(sunMoonAnimationPosition, forKey: "position")
        sunSublayer.position = isOn ? .init(x: 271, y: 70) : .init(x: 74, y: 70)
        sunSublayer.add(sunMoonAnimationPosition, forKey: "position")
        
        
        let clouds1Animation = CABasicAnimation(keyPath: "position")
        clouds1Animation.duration = duration
        clouds1Animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        clouds1Animation.fromValue = isOn ? [0, 0] : [59, 72]
        clouds1Animation.toValue = isOn ? [59, 72] : [0, 0]
        cloudsLayer1.position = isOn ? .init(x: 59, y: 72) : .init(x: 0, y: 0)
        cloudsLayer1.add(clouds1Animation, forKey: "position")
        
        
        let clouds2Animation = CABasicAnimation(keyPath: "position")
        clouds2Animation.duration = duration
        clouds2Animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        clouds2Animation.fromValue = isOn ? [0, 0] : [45, 55]
        clouds2Animation.toValue = isOn ? [45, 55] : [0, 0]
        cloudsLayer2.position = isOn ? .init(x: 45, y: 55) : .init(x: 0, y: 0)
        cloudsLayer2.add(clouds2Animation, forKey: "position")
        
        
        let starsAnimation1 = CABasicAnimation(keyPath: "position")
        starsAnimation1.toValue = isOn ? [0, 0] : [-30, -70]
        starsAnimation1.fromValue = isOn ? [-30, -70] : [0, 0]
        starsAnimation1.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        starsAnimation1.duration = duration
        starsLayer1.position = isOn ? .init(x: 0, y: 0) : .init(x: -30, y: -70)
        starsLayer1.add(starsAnimation1, forKey: "position")
        
        
        let starsAnimation2 = CABasicAnimation(keyPath: "position")
        starsAnimation2.toValue = isOn ? [0, 0] : [-50, -120]
        starsAnimation2.fromValue = isOn ? [-50, -120] : [0, 0]
        starsAnimation2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        starsAnimation2.duration = duration
        starsLayer2.position = isOn ? .init(x: 0, y: 0) : .init(x: -50, y: -120)
        starsLayer2.add(starsAnimation2, forKey: "position")
        
        
        let moonAnimation = CABasicAnimation(keyPath: "opacity")
        moonAnimation.fromValue = isOn ? 0 : 1
        moonAnimation.toValue = isOn ? 1 : 0
        moonAnimation.duration = duration
        moonAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        moonLayer.opacity = isOn ? 1 : 0
        moonLayer.add(moonAnimation, forKey: "opacity")
        
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowColor")
        shadowAnimation.fromValue = isOn ? UIColor.white.cgColor : UIColor.darkGray.cgColor
        shadowAnimation.toValue = isOn ? UIColor.darkGray.cgColor : UIColor.white.cgColor
        shadowAnimation.duration = duration
        backgroundInnerShadow.shadowColor = isOn ? UIColor.darkGray.cgColor : UIColor.white.cgColor
        backgroundInnerShadow.add(shadowAnimation, forKey: "shadowColor")
        
    }
}

extension CAShapeLayer {
    func getInnerShadow(x: Int, y: Int, radius: CGFloat, opacity: Float, color: UIColor) -> CAShapeLayer {
        guard let path = self.path else { return CAShapeLayer() }
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = CGRect(x: bounds.origin.x - 10, y: bounds.origin.y - 10, width: bounds.width + 20, height: bounds.height + 20)
        shadowLayer.bounds = CGRect(x: -10, y: -10, width: shadowLayer.frame.width, height: shadowLayer.frame.height)
        shadowLayer.shadowOffset = .init(width: x, height: y)
        shadowLayer.shadowRadius = radius / 2
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowColor = color.cgColor
        
        let cutoutPath = UIBezierPath(cgPath: path).reversing()
        
        let shadowPath = UIBezierPath(rect: shadowLayer.bounds)
        shadowPath.append(cutoutPath)
        shadowLayer.path = shadowPath.cgPath
        
        let layerMask = CAShapeLayer()
        layerMask.path = path
        shadowLayer.mask = layerMask
        return shadowLayer
    }
}


