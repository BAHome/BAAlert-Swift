//
//  BAAlert_Config.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/17.
//  Copyright © 2017年 boai. All rights reserved.
//

import Foundation
import UIKit

// frame 类
var SCREENWIDTH = UIScreen.main.bounds.size.width
var SCREENHEIGHT = UIScreen.main.bounds.size.height

var BAKit_BaseScreenWidth : CGFloat = 320.0
var BAKit_BaseScreenHeight : CGFloat = 568.0

var BAKit_ScaleXAndWidth = SCREENWIDTH / BAKit_BaseScreenWidth
var BAKit_ScaleYAndHeight = SCREENHEIGHT / BAKit_BaseScreenHeight

var kBAAlert_Width : CGFloat = SCREENWIDTH - 50 * 2
var kBAAlert_Padding : CGFloat = 10
var kBAAlert_Radius : CGFloat = 10
var kBAAlert_ButtonHeight : CGFloat = 40

// 颜色类
var BAAlert_Color_RGBA : (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = {
    return UIColor(red: $0/255.0, green: $1/255.0, blue: $2/255.0, alpha: $3)
}
var BAAlert_Color_Translucent = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
var BAAlert_Color_Line = BAAlert_Color_RGBA(160, 170, 160, 0.5)
var BAAlert_Color_gray11 = BAAlert_Color_RGBA(248, 248, 248, 1.0)
var BAAlert_Color_gray7 = BAAlert_Color_RGBA(173, 180, 190, 1.0)


// lable 自适应宽高
func BAKit_LabelSizeWithTextAndWidthAndFont(string: String, width : CGFloat, font : UIFont) -> CGSize {
    let statusLabelText: NSString = (string as NSString)
    
    let size = CGSize(width: width, height:CGFloat(CGFloat.greatestFiniteMagnitude))
    
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)

    let newSize = statusLabelText.boundingRect(with: size, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: dic as? [NSAttributedStringKey : Any], context: nil).size;
    
    return newSize
}

/*! 背景高斯模糊枚举 默认：1 */
enum BAAlertBlurEffectStyle : NSInteger {
    /*! 较亮的白色模糊 */
    case BAAlertBlurEffectStyleExtraLight = 1
    /*! 一般亮的白色模糊 */
    case BAAlertBlurEffectStyleLight
    /*! 深色背景模糊 */
    case BAAlertBlurEffectStyleDark
}

/*! 进出场动画枚举 默认：1 */
enum BAAlertAnimatingStyle : NSInteger {
    /*! 缩放显示动画 */
    case BAAlertAnimatingStyleScale = 1
    /*! 晃动动画 */
    case BAAlertAnimatingStyleShake
    /*! 天上掉下动画 / 上升动画 */
    case BAAlertAnimatingStyleFall
}

/*! BAActionSheet 样式 */
enum BAActionSheetStyle : NSInteger{
    /*!
     *  普通样式
     */
    case BAActionSheetStyleNormal = 1
    /*!
     *  带标题样式
     */
    case BAActionSheetStyleTitle
    /*!
     *  带图片和标题样式
     */
    case BAActionSheetStyleImageAndTitle
    /*!
     *  带图片样式
     */
    case BAActionSheetStyleImage
};

/*!
 * 按钮点击事件回调
 */
typealias BAAlert_ButtonActionBlock = (_ index : NSInteger) -> Void
