//
//  BAAlert_Animation.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/9.
//  Copyright © 2017年 boai. All rights reserved.
//

import Foundation
import UIKit

public typealias finishBlock = () -> ()


extension CALayer {
    /*!
     *  晃动动画
     *
     *  @param duration 一次动画用时
     *  @param radius   晃动角度0-180
     *  @param repeatCount   重复次数
     *  @param finish   动画完成
     */
    func shakeAnimationWithDuration(duration:TimeInterval, radius : Double, repeatCount : Float, finish : @escaping finishBlock)  {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.duration = duration
        keyAnimation.keyPath = "transform.rotation.z"
        keyAnimation.values = [NSNumber.init(value: (0) / 180.0 * .pi),
                               NSNumber.init(value: (-radius) / 180.0 * .pi),
                               NSNumber.init(value: (radius) / 180.0 * .pi),
                               NSNumber.init(value: (-radius) / 180.0 * .pi),
                               NSNumber.init(value: (0) / 180.0 * .pi)]
        keyAnimation.repeatCount = repeatCount
        self.add(keyAnimation, forKey: nil)
        
        if (finish != nil) {
            let delay : Float = Float(duration) * (repeatCount) - 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
                finish()
            }
        }
    }
    
    /*!
     *  根据路径执行动画
     *
     *  @param duration 一次动画用时
     *  @param path     路径CGPathRef
     *  @param repeat   重复次数
     *  @param finish   动画完成
     */
    func pathAnimationWithDuration(duration:TimeInterval, path : CGPath, repeatCount : Float, finish :  @escaping finishBlock)  {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.duration = duration
        keyAnimation.keyPath = "position"
        keyAnimation.repeatCount = repeatCount
        keyAnimation.fillMode = kCAFillModeForwards
        keyAnimation.path = path
        self.add(keyAnimation, forKey: nil)
        
        if ((finish) != nil) {
            let delay : Float = Float(duration) * (repeatCount) - 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
                finish()
            }
        }
    }
    
    /*! 这两个动画只适合本项目 */
    /*! 天上掉下 */
    func fallAnimationWithDuration(duration:TimeInterval, finish :  @escaping finishBlock)  {
        let frame = UIScreen.main.bounds
        
        let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        
        let point = CGPoint(x: frame.width * 0.5, y: -(self.frame.height))
        
        let path = UIBezierPath()
        
        path.move(to: point)
        
        path.addLine(to: center)
        
        self.pathAnimationWithDuration(duration: duration, path: path.cgPath, repeatCount: 1.0) { () in
            if (finish != nil)
            {
                finish()
            }
        }
    }
    
    /*! 上升 */
    func floatAnimationWithDuration(duration:TimeInterval, finish :  @escaping finishBlock)  {
        let frame = UIScreen.main.bounds
        
        let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        
        let point = CGPoint(x: frame.width * 0.5, y: -(self.frame.height))
        
        let path = UIBezierPath()
        
        path .move(to: center)
        
        path.addLine(to: point)
        
        self.pathAnimationWithDuration(duration: duration, path: path.cgPath, repeatCount: 1.0) { () in
            if (finish != nil)
            {
                finish()
            }
        }
    }
    
}

extension UIView {
    /**
     缩放显示动画
     
     - parameter finish: 动画完成
     */
    func scaleAnimationShowFinishAnimation(finish : @escaping finishBlock)  {
        transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.35, animations: { 
            self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
            }) { (finished) in
                UIView.animate(withDuration: 0.25, animations: { 
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: { (finifhed) in
                        if finished {
                            finish()
                        }
                })
        }
    }
    /**
     缩放隐藏动画
     
     - parameter finish:   动画完成
     */
    func scaleAnimationDismissFinishAnimation(finish :  @escaping finishBlock)  {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
        }) { (finished) in
            
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }, completion: { (finifhed) in
                    if finished {
                        finish()
                    }
            })
        }
    }
}
