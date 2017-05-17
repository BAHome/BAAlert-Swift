//
//  BAActionSheetCell.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/15.
//  Copyright © 2017年 boai. All rights reserved.
//

import UIKit

class BAActionSheetCell: UITableViewCell {
    
    var actionSheetType:BAActionSheetType?
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        
        var min_x : CGFloat = 0.0
        var min_y : CGFloat = 0.0
        var min_w : CGFloat = 0.0
        var min_h : CGFloat = 0.0
        
        min_x = 10
        min_y = 7
        min_w = 30
        min_h = 30
        if actionSheetType == .BAActionSheetTypeNormalLeft {
            if self.imageView?.frame.width == 0 {
                min_w = 0 
            }
            self.imageView?.frame = CGRect(x : min_x, y : min_y, width : min_w, height : min_h)
        }
        else if actionSheetType == .BAActionSheetTypeNormalCenter{
            
            if self.imageView?.frame.width == 0 {
                
                min_w = 0
                min_x = self.center.x - min_w/2.0 - (self.textLabel?.frame.width)!/2.0 - 10
            }
            else
            {
                min_x = self.center.x - min_w * 2.0
            }
            self.imageView?.frame = CGRect(x : min_x, y : min_y, width : min_w, height : min_h)
            
        }
        else if actionSheetType == .BAActionSheetTypeExpand{
            
        }
        
        min_x = (self.imageView?.frame.maxX)! + 10
        min_w = self.frame.width - min_x - 5
        self.textLabel?.frame = CGRect(x: min_x , y: (self.textLabel?.frame.minY)!, width: min_w, height: (self.textLabel?.frame.height)!)
        
        self.detailTextLabel?.frame = CGRect(x: (self.textLabel?.frame.minX)!, y: (self.detailTextLabel?.frame.minY)!, width: min_w, height: (self.detailTextLabel?.frame.height)!)
        

    }
    
}
