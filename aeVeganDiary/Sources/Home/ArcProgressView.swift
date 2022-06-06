//
//  ArcProgressView.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/06.
//

import UIKit

class ArcProgressView: UIView {
    public var progressBackgoundColor = UIColor.lightGray
    public var oneProgressForegroundColor = UIColor.red
    
    public var lineWidth:CGFloat = 10 {
        didSet{
            foregroundLayerOne.lineWidth = lineWidth
            backgroundLayerOne.lineWidth = lineWidth
        }
    }
    
    public var duration: Double = 0.5
    
    public var labelSize: CGFloat = 10.0 {
        didSet {
            oneLabel.font = UIFont.systemFont(ofSize: labelSize, weight: .bold)
            oneLabel.textColor = oneProgressForegroundColor
            oneLabel.sizeToFit()
            configLabel()
        }
    }
    
    public func setProgressOne(to progressConstant: Double, withAnimation: Bool, maxSpeed: Double) {
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        foregroundLayerOne.strokeEnd = CGFloat(progress)
        
        //self.oneLabel.text = "\(Int((maxSpeed/100) * progress*100))"
        self.configLabel()
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = duration
            foregroundLayerOne.add(animation, forKey: "foregroundAnimation")
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= self.duration{
                timer.invalidate()
            } else {
                currentTime += 0.05
                self.setForegroundLayerColorForSpeed()
            }
        }
        timer.fire()
    }
   
    
    //MARK: Private
    private var oneLabel = UILabel()
    private let foregroundLayerOne = CAShapeLayer()
    private let backgroundLayerOne = CAShapeLayer()
    
    private var radius: CGFloat {
        get{
            return (min(self.frame.width, self.frame.height) - lineWidth)/2
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayerSpeed()
        drawForegroundLayerSpeed()
    }
    
    
    // MARK: Speed bar
    private let oneStartAngle = CGFloat.pi*2.6/3
    private let oneEndAngle = CGFloat.pi*6/3
    
    private func drawBackgroundLayerSpeed(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: oneStartAngle , endAngle: oneEndAngle, clockwise: true)
        self.backgroundLayerOne.path = path.cgPath
        self.backgroundLayerOne.strokeColor = progressBackgoundColor.cgColor
        self.backgroundLayerOne.lineWidth = lineWidth
        self.backgroundLayerOne.lineCap = CAShapeLayerLineCap.round
        self.backgroundLayerOne.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayerOne)
    }
    
    private func drawForegroundLayerSpeed(){
        let startAngle = oneStartAngle
        let endAngle = oneEndAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayerOne.lineCap = CAShapeLayerLineCap.round
        foregroundLayerOne.path = path.cgPath
        foregroundLayerOne.lineWidth = lineWidth
        foregroundLayerOne.fillColor = UIColor.clear.cgColor
        foregroundLayerOne.strokeColor = oneProgressForegroundColor.cgColor
        foregroundLayerOne.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayerOne)
        
    }
    
    private func configLabel(){
        oneLabel.sizeToFit()
        oneLabel.center = pathCenter
    }
    
    private func setForegroundLayerColorForSpeed(){
        self.foregroundLayerOne.strokeColor = oneProgressForegroundColor.cgColor
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(oneLabel)
    }
    
    //Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = oneLabel.text
            setupView()
            oneLabel.text = tempText
            layoutDone = true
        }
    }
}
