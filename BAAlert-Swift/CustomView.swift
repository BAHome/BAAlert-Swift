//
//  CustomView.swift
//  BAAlert-Swift
//
//  Created by apple on 2017/5/15.
//  Copyright © 2017年 boai. All rights reserved.
//

import UIKit

class CustomView: UIView {
    var buttonActionBlock:BAAlert_ButtonActionBlock?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewPwdBgView.frame = self.bounds
       
        titleLabel.frame = CGRect(x:10,y:0,width:viewPwdBgView.frame.width - 20,height:40)
        
        lineView1.frame = CGRect(x:0,y:titleLabel.frame.maxY,width:viewPwdBgView.frame.width ,height:1)
        
        pwdTextField.frame = CGRect(x:0,y:titleLabel.frame.maxY,width:viewPwdBgView.frame.width - 30 ,height:50)
        pwdTextField.center = viewPwdBgView.center
        
        lineView2.frame = CGRect(x:0,y:viewPwdBgView.frame.height - 40,width:viewPwdBgView.frame.width ,height:1)
        
        cancleButton.frame = CGRect(x:0,y:lineView2.frame.maxY,width:viewPwdBgView.frame.width / 2.0 ,height:40)
        
        sureButton.frame = CGRect(x:cancleButton.frame.width,y:cancleButton.frame.minY,width:cancleButton.frame.width ,height:40)
        
        
    }
    
    //MARK: - Custom Method
    @objc private func handleButtonAction(button:UIButton)
    {
       pwdTextField.resignFirstResponder()
        if (buttonActionBlock != nil) {
            buttonActionBlock?(button.tag)
        }
       
        
    }
    
    //MARK: - setter / getter
    private lazy var viewPwdBgView:UIView = {
        
        var viewPwdBgView = UIView()
        viewPwdBgView.clipsToBounds = true
        viewPwdBgView.layer.cornerRadius = 10.0
        viewPwdBgView.backgroundColor = UIColor.white
        self.addSubview(viewPwdBgView)
        
        return viewPwdBgView;
    }()
    
    private lazy var titleLabel:UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "请补全好友姓名，确保信息安全"
        titleLabel.adjustsFontSizeToFitWidth = true
        self.viewPwdBgView.addSubview(titleLabel)
        
        return titleLabel;
    }()
    
    private lazy var lineView1:UIView = {
        
        var lineView1 = UIView()
        lineView1.backgroundColor = UIColor.lightGray
        self.viewPwdBgView.addSubview(lineView1)
        
        return lineView1;
    }()
    
    private lazy var pwdTextField:UITextField = {
        
        var pwdTextField = UITextField()
        pwdTextField.borderStyle = UITextBorderStyle.roundedRect
        
        self.viewPwdBgView.addSubview(pwdTextField)
        
        return pwdTextField;
    }()
    
    private lazy var lineView2:UIView = {
        
        var lineView2 = UIView()
        lineView2.backgroundColor = UIColor.lightGray
        self.viewPwdBgView.addSubview(lineView2)

        return lineView2;
    }()
    
    private lazy var cancleButton:UIButton = {
        
        var cancleButton = UIButton()
        cancleButton.setTitle("取消", for: UIControlState.normal)
        cancleButton.backgroundColor = UIColor.green
        cancleButton.addTarget(self, action: #selector(handleButtonAction(button:)), for:UIControlEvents.touchUpInside)
        cancleButton.tag = 1
        self.viewPwdBgView.addSubview(cancleButton)

        return cancleButton;
    }()
    
    private lazy var sureButton:UIButton = {
        
        var sureButton = UIButton()
        sureButton.backgroundColor = UIColor.red
        sureButton.setTitle("确定", for: UIControlState.normal)
        sureButton.addTarget(self, action: #selector(handleButtonAction(button:)), for:UIControlEvents.touchUpInside)
        sureButton.tag = 2
        self.viewPwdBgView.addSubview(sureButton)

        return sureButton;
    }()
    

}

