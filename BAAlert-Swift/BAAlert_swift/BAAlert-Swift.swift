//
//  BAAlert-Swift.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/9.
//  Copyright © 2017年 boai. All rights reserved.
//

import Foundation
import UIKit

var SCREENWIDTH = UIScreen.main.bounds.size.width
var SCREENHEIGHT = UIScreen.main.bounds.size.height

func BAKit_LabelSizeWithTextAndWidthAndFont(string: String, width : CGFloat, font : UIFont) -> CGSize {
    let statusLabelText: String = string
    
    let size = CGSize(width: width, height:CGFloat(CGFloat.greatestFiniteMagnitude))
    
    let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
    
    let newSize = statusLabelText.boundingRect(with: size, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: dic as? [String : Any] , context: nil).size;
    
    return newSize
}

