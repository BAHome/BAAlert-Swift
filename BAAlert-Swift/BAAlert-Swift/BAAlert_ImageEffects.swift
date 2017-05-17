//
//  BAAlertImageEffects.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/10.
//  Copyright © 2017年 boai. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIImage {
    func BAAlert_ApplyLightEffect() -> UIImage! {
        let tintColor = UIColor(white:0.3,alpha:0.4)
        return BAAlert_ApplyBlurWithRadius(blurRadius: 1.3, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func BAAlert_ApplyExtraLightEffect() -> UIImage! {
        let tintColor = UIColor(white:0.97,alpha:0.82)
        return BAAlert_ApplyBlurWithRadius(blurRadius: 2, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func BAAlert_ApplyDarkEffect() -> UIImage! {
        let tintColor = UIColor(white:0.11,alpha:0.73)
        return BAAlert_ApplyBlurWithRadius(blurRadius: 20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func BAAlert_ApplyTintEffectWithColor(tintColor : UIColor) -> UIImage! {
        let EffectColorAlpha : CGFloat = 0.45
        var effectColor : UIColor = tintColor
        
        let componentCount = tintColor.cgColor.numberOfComponents
        
        if (componentCount == 2) {
            var b : CGFloat = 0.0
            if ( tintColor.getWhite(&b, alpha: nil) ) {
                effectColor = UIColor(white:b,alpha:EffectColorAlpha)
            }
        }
        else {
            var r : CGFloat = 0.0
            var g : CGFloat = 0.0
            var b : CGFloat = 0.0
            
            if ( tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) ) {
                
                effectColor = UIColor(red: r, green: g, blue: b, alpha: EffectColorAlpha)
                
            }
        }
        return self.BAAlert_ApplyBlurWithRadius(blurRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    func BAAlert_ApplyBlurWithRadius(blurRadius : CGFloat, tintColor : UIColor?, saturationDeltaFactor : Double, maskImage : UIImage?) -> UIImage! {
        // Check pre-conditions.
        if (self.size.width < 1 || self.size.height < 1)
        {
            print("*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self)
            return nil
        }
        if ( self.cgImage == nil )
        {
            print("*** error: image must be backed by a CGImage: %@", self)
            return nil
        }
        if ( maskImage != nil && (maskImage!.cgImage == nil) )
        {
//            print("*** error: maskImage must be backed by a CGImage: %@", maskImage ?? <#default value#>)
            return nil
        }
//        if (blurRadius < 0.0 || blurRadius > 1.0) {
//            blurRadius = 0.5
//        }
        
        
        
        let imageRect = CGRect(origin: CGPoint.zero, size: self.size)
        var effectImage : UIImage = self
        
        let hasBlur : Bool = blurRadius > .ulpOfOne
        
        let hasSaturationChange : Bool = fabs(Float(saturationDeltaFactor) - 1.0) > .ulpOfOne
        
        let screenScale = UIScreen.main.scale
        
        
        if ( hasBlur || hasSaturationChange ) {
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, screenScale)
            
            let effectInContext : CGContext = UIGraphicsGetCurrentContext()!
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -self.size.height)
        
            effectInContext.draw(self.cgImage!, in: imageRect)
            
            var effectInBuffer = vImage_Buffer()
            effectInBuffer.data     = effectInContext.data
            effectInBuffer.width    = vImagePixelCount(effectInContext.width)
            effectInBuffer.height   = vImagePixelCount(effectInContext.height)
            effectInBuffer.rowBytes = effectInContext.bytesPerRow
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, screenScale)
            let effectOutContext : CGContext = UIGraphicsGetCurrentContext()!
            
            var effectOutBuffer = vImage_Buffer()
            effectOutBuffer.data     = effectOutContext.data
            effectOutBuffer.width    = vImagePixelCount(effectOutContext.width)
            effectOutBuffer.height   = vImagePixelCount(effectOutContext.height)
            effectOutBuffer.rowBytes = effectOutContext.bytesPerRow
            
            if ( hasBlur ) {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                let inputRadius : Double = Double(blurRadius) * Double(screenScale)
                
                var radius = floor(inputRadius * 3.0 * sqrt(2 * .pi) / 4 + 0.5)
                
                
                let result = radius.truncatingRemainder(dividingBy: 2)
                
                if (result != 1) {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                var unsafePointer : UInt8 = 0
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
            }
            
            var effectImageBuffersAreSwapped : Bool = false
            
            if ( hasSaturationChange ) {
                let s : Double = saturationDeltaFactor
                let floatingPointSaturationMatrix : [Double] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1,
                ]
                
                let divisor : Int32 = 256
                let matrixSize : Int = MemoryLayout.size(ofValue: floatingPointSaturationMatrix) / MemoryLayout.size(ofValue: floatingPointSaturationMatrix[0])
                
                var saturationMatrix = [Int16]()
                
                for _ in 0...matrixSize {
                    saturationMatrix.append(0)
                }
                
                for i in 0...matrixSize {
                    saturationMatrix[i] = Int16(roundf(Float(floatingPointSaturationMatrix[i]) * Float(divisor)))
                }
                
                if (hasBlur) {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                }
                else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                }
            }
            if ( !effectImageBuffersAreSwapped ) {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
            
            if ( effectImageBuffersAreSwapped ) {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
        
        // 开启上下文 用于输出图像
        UIGraphicsBeginImageContextWithOptions(self.size, false, screenScale)
        let outputContext : CGContext = UIGraphicsGetCurrentContext()!
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -self.size.height)
        
        // 开始画底图
        outputContext.draw(self.cgImage!, in: imageRect)
    
        //CGContextDrawImage(outputContext, imageRect, self.cgImage)
        
        // 开始画模糊效果
        if (hasBlur) {

            outputContext.saveGState()
            if ( (maskImage) != nil) {
                outputContext.draw(maskImage!.cgImage!, in: imageRect)
            }
            else
            {
                outputContext.draw(effectImage.cgImage!, in: imageRect)

            }
            
            //CGContextDrawImage(outputContext, imageRect, effectImage.cgImage)
            outputContext.restoreGState()
        }
        
        // 添加颜色渲染
        if ( tintColor != nil ) {
            outputContext.saveGState()
            outputContext.setFillColor(tintColor!.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        // 输出成品,并关闭上下文
        let outputImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    //MARK: - 纯颜色转图片
    static func BAAlert_ImageWithColor(color : UIColor) -> UIImage! {
        return self.BAAlert_ImageWithColor(color: color, size: CGSize(width: 1.0, height: 1.0))
    }
    
    static func BAAlert_ImageWithColor(color : UIColor, size : CGSize) -> UIImage! {
        let rect : CGRect          = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        
        context.fill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func screenShotImage() -> UIImage! {
        
        let window : UIWindow = UIApplication.shared.windows.first!
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:window.frame.width,height: window.frame.height), true, 1.0);
        //
        //    /*! 设置截屏大小 */
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return viewImage
    }
}
