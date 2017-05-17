//
//  BAAlert.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/10.
//  Copyright © 2017年 boai. All rights reserved.
//

import Foundation
import UIKit


private enum BAAlertType : Int {
    case BAAlertTypeNormal = 0
    case BAAlertTypeCustom
}

class BAAlert : UIView {
    
    // MARK: - 公开属性
    /*! 背景颜色 默认：半透明*/
    var bgColor : UIColor? = BAAlert_Color_Translucent
    
    /*! 是否开启边缘触摸隐藏 alert 默认：false */
    var isTouchEdgeHide : Bool = false
    
    /*! 背景图片名字 默认：没有图片*/
    var bgImageName : String? {
        willSet {
            if newValue == nil {
                containerView.backgroundColor = .white
                scrollView.backgroundColor = .white
                containerView.image = nil
            }
            else {
                containerView.backgroundColor = .clear
                scrollView.backgroundColor = .clear
                containerView.image = UIImage.init(named: newValue!)
                containerView.contentMode = .scaleToFill
            }
        }
    }
    
    /*! 是否开启进出场动画 默认：NO，如果 YES ，并且同步设置进出场动画枚举为默认值：1 */
    var showAnimate : Bool = false
    
    /*! 进出场动画枚举 默认：1 ，并且默认开启动画开关 */
    var animatingStyle : BAAlertAnimatingStyle?
    
    /*! 背景高斯模糊枚举 默认：1 */
    var blurEffectStyle : BAAlertBlurEffectStyle?
    
    // MARK: - 公开方法
    /*!
     *  创建一个完全自定义的 alertView，注意：【自定义 alert 只适用于竖屏状态！】
     *
     *  @param customView    自定义 View
     *  @param configuration 属性配置：如 bgColor、buttonTitleColor、isTouchEdgeHide...
     */
    static func ba_alertShowCustomView(customView : UIView, configuration : (BAAlert) -> Void) {
        let tempView = BAAlert()
        tempView.initWithCustomView(customView: customView)
        configuration(tempView)
        tempView.ba_showAlertView()
    }
    
    /*!
     *  创建一个类似于系统的alert
     *
     *  @param title         标题：可空
     *  @param message       消息内容：可空
     *  @param image         图片：可空
     *  @param buttonTitles  按钮标题：不可空
     *  @param buttonTitlesColor  按钮标题颜色：可空，默认蓝色
     *  @param configuration 属性配置：如 bgColor、buttonTitleColor、isTouchEdgeHide...
     *  @param action        按钮的点击事件处理
     */
    static func ba_alertShowWithTitle(title : String, message : String, image : UIImage?, buttonTitleArray : [String]?, buttonTitleColorArray : [UIColor], configuration : (BAAlert) -> Void, block : @escaping BAAlert_ButtonActionBlock) {
        let tempView = BAAlert()
        tempView.ba_showTitle(title: title, message: message, image: image, buttonTitleArray: buttonTitleArray, buttonTitleColorArray : buttonTitleColorArray)
        configuration(tempView)
        tempView.buttonActionBlock = block
        tempView.ba_showAlertView()
    }
    
    /*!
     *  视图消失
     */
    func ba_alertHidden() -> Void {
        
        if showAnimate {
            dismissAnimationView(animationView: (alertType == .BAAlertTypeNormal) ? containerView:customView)
        }
        else
        {
            ba_removeSelf()
        }
    }
    
    // MARK: - 私有属性
    private var title : String?
    private var message : String?
    private var image : UIImage?
    
    private var alertType : BAAlertType?
    
    private var customView = UIView()
    private var customView_frame = CGRect()
    private var buttonActionBlock : BAAlert_ButtonActionBlock?

    private var current_blurEffectStyle : BAAlertBlurEffectStyle = .BAAlertBlurEffectStyleExtraLight {
        
        didSet{
            blurImageView.image = nil
            blurImageView.image = getCurrentWindowImage()
            
            switch current_blurEffectStyle {
                /*! 较亮的白色模糊 */
            case .BAAlertBlurEffectStyleLight:
                blurImageView.image = blurImageView.image?.BAAlert_ApplyLightEffect()
                break
                /*! 一般亮的白色模糊 */
            case .BAAlertBlurEffectStyleExtraLight:
                blurImageView.image = blurImageView.image?.BAAlert_ApplyExtraLightEffect()
                break
                /*! 深色背景模糊 */
            case .BAAlertBlurEffectStyleDark:
                blurImageView.image = blurImageView.image?.BAAlert_ApplyDarkEffect()
                break
            }
        }
    }
    
    private var view_width : CGFloat = 0.0
    private var view_height : CGFloat = 0.0
    
    private var _scroll_bottom : CGFloat = 0.0
    private var _button_totalHeight : CGFloat = 0.0
    private var _maxContent_Width : CGFloat = 0.0
    private var _maxContent_Height : CGFloat = 0.0

    // MARK: - init
    private func initWithCustomView(customView : UIView) -> Void {
        self.customView = customView
        
        self.alertType = .BAAlertTypeCustom
        self.customView_frame = customView.frame
        
        self.setupCommonUI()
        self.addSubview(self.customView)
        
    }
    
    private func ba_showTitle(title : String, message : String, image : UIImage?, buttonTitleArray : [String]?, buttonTitleColorArray : [UIColor]) -> Void {

        self.title = title
        self.image = image
        self.message = message
        
        self.buttonTitleArray = buttonTitleArray!
        self.buttonTitleColorArray = buttonTitleColorArray
        self.alertType = .BAAlertTypeNormal
        
        setupCommonUI()
    }
    
    // MARK: - custom method
    
    private func setupCommonUI() -> Void {
        backgroundColor = BAAlert_Color_Translucent
        
        blurImageView.isHidden = false
        blurEffectStyle = .BAAlertBlurEffectStyleLight
        animatingStyle = .BAAlertAnimatingStyleScale

        
        if alertType == .BAAlertTypeCustom {
            NSLog("【 BAAlert 】注意：【自定义 alert 只适用于竖屏状态！】");
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowAction(noti:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHiddenAction(noti:)), name: .UIKeyboardWillHide, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationRotateAction(noti:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    private func ba_removeSelf() -> Void {
        //        NSLog("【 %@ 】已经释放！", self.classForCoder)
        
        titleLabel.removeFromSuperview()
        imageView.removeFromSuperview()
        messageLabel.removeFromSuperview()
        customView.removeFromSuperview()
        containerView.removeFromSuperview()
        blurImageView.removeFromSuperview()
        scrollView.removeFromSuperview()
        
        removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: 通知处理
    @objc private func handleKeyboardShowAction(noti : NSNotification) -> Void {
        
        var infoDic = noti.userInfo
        
        let duration:CGFloat = infoDic?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        let  keyBoardRect:CGRect   = infoDic?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        var viewFrame = self.customView.frame
        let  height_different:CGFloat = viewFrame.maxY - keyBoardRect.minY
        if(height_different > 0)
        {
            viewFrame.origin.y -= height_different;
            viewFrame.origin.y -= 10;
            UIView.animate(withDuration: TimeInterval(duration), animations: { 
                self.customView.frame = viewFrame;
            });
            
        }
    }
    
    @objc private func handleKeyboardHiddenAction(noti : NSNotification) -> Void {
        var infoDic = noti.userInfo
        
        let duration:CGFloat = infoDic?[UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.customView.frame = self.customView_frame;
        });
    }
    
    @objc private func handleDeviceOrientationRotateAction(noti : NSNotification) -> Void {
        ba_layoutSubViews()
    }
    
    // MARK: 视图显示
    private func ba_showAlertView() -> Void {
        alertWindow.addSubview(self)
        
        ba_layoutSubViews()
        
        /*! 设置默认样式为： */
        if showAnimate && (animatingStyle == nil) {
            animatingStyle = .BAAlertAnimatingStyleScale
        }
        /*! 如果没有开启动画，就直接默认第一个动画样式 */
        else if !showAnimate && (animatingStyle != nil) {
            showAnimate = true
        }
        else {
            if (animatingStyle == nil) {
                NSLog("您没有开启动画，也没有设置动画样式，默认为没有动画！");
            }
        }
        
        if showAnimate {
            showAnimationWithView(animationView: (alertType == .BAAlertTypeNormal) ? containerView:customView)
        }
        
    }
    
    // MARK: 进场动画
    private func showAnimationWithView(animationView : UIView) -> Void {
        
        if animatingStyle == .BAAlertAnimatingStyleScale {
            animationView.scaleAnimationShowFinishAnimation(finish: { () in
                })
        }
        else if animatingStyle == .BAAlertAnimatingStyleShake {
            animationView.layer.shakeAnimationWithDuration(duration: 0.35, radius: 16.0, repeatCount: 1.0, finish: { () in
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleFall {
            animationView.layer.fallAnimationWithDuration(duration: 0.35, finish: { 
                
            })
        }
    }
    
    private func dismissAnimationView(animationView : UIView) -> Void {
        
        if animatingStyle == .BAAlertAnimatingStyleScale {
            animationView.scaleAnimationDismissFinishAnimation(finish: {
                self.ba_removeSelf()
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleShake {
            animationView.layer.floatAnimationWithDuration(duration: 0.35, finish: {
                self.ba_removeSelf()
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleFall {
            animationView.layer.floatAnimationWithDuration(duration: 0.35, finish: { 
                self.ba_removeSelf()
            })
        }
    }
    
    // MARK: 布局
    private func ba_layoutSubViews() -> Void {
        self.frame = UIScreen.main.bounds
        alertWindow.frame = UIScreen.main.bounds
        
        blurImageView.image = nil
        blurImageView.frame = UIScreen.main.bounds
        self.current_blurEffectStyle = self.blurEffectStyle!

        view_width = UIScreen.main.bounds.size.width
        view_height = UIScreen.main.bounds.size.height
        
        if alertType == .BAAlertTypeNormal {
            layoutNormalAlert()
        }
        else if alertType == .BAAlertTypeCustom {
            customView.frame = customView_frame
        }
    }
    
    private func layoutNormalAlert() -> Void {
        ba_resetButtons()
        
        var min_x : CGFloat = 0.0
        var min_y : CGFloat = 0.0
        var min_w : CGFloat = 0.0
        var min_h : CGFloat = 0.0
        
        _scroll_bottom = 0
        
        _maxContent_Width = view_width - 50 * BAKit_ScaleXAndWidth * 2
        _maxContent_Height = view_height - 20 * BAKit_ScaleYAndHeight * 2
        
        let button_row : NSInteger = ((buttonTitleArray.count > 2 || buttonTitleArray.count == 0) ? buttonTitleArray.count : 1)
        _button_totalHeight = kBAAlert_ButtonHeight * CGFloat(button_row)
        
        // 标题
        min_x = kBAAlert_Padding
        min_w = _maxContent_Width - kBAAlert_Padding * 2
        let titleLabel_size : CGSize = BAKit_LabelSizeWithTextAndWidthAndFont(string: titleLabel.text!, width: min_w, font: titleLabel.font)
        min_h = titleLabel_size.height
        titleLabel.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)

        min_y = titleLabel.frame.maxY + kBAAlert_Padding
        min_h = 0.5
        addLine(frame: CGRect(x: min_x, y: min_y, width: min_w, height: min_h), view: scrollView)
        
        // 图片
        min_y = titleLabel.frame.maxY + kBAAlert_Padding * 2
        var imageView_size = image?.size
        if imageView_size != nil {
            if (imageView_size?.width)! > _maxContent_Width {
                imageView_size?.height = (imageView_size?.height)! / (imageView_size?.width)! * _maxContent_Width
                imageView_size?.width = _maxContent_Width
            }
            min_w = (imageView_size?.width)! - kBAAlert_Padding * 2
            min_h = (imageView_size?.height)!
        }
        else
        {
            min_w = 0
            min_h = 0
        }
        imageView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        
        // message
        if min_h <= 0 {
            min_y = titleLabel.frame.maxY + kBAAlert_Padding * 2
        }
        else {
            min_y = imageView.frame.maxY + kBAAlert_Padding
        }
        min_w = titleLabel.frame.width
        let messageLabel_size : CGSize = BAKit_LabelSizeWithTextAndWidthAndFont(string: messageLabel.text!, width: min_w, font: messageLabel.font)
        min_h = messageLabel_size.height
        messageLabel.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        _scroll_bottom = messageLabel.frame.maxY + kBAAlert_Padding
        
        min_x = 0
        min_y = 0
        min_w = _maxContent_Width
        min_h = min(max(_scroll_bottom + kBAAlert_Padding * 2 + _button_totalHeight, kBAAlert_Padding * 3), _maxContent_Height)
        containerView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        containerView.center = self.center
        
        min_y = kBAAlert_Padding
        min_h = min(_scroll_bottom, self.containerView.frame.height - kBAAlert_Padding * 2 - _button_totalHeight)
        scrollView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        scrollView.contentSize = CGSize(width: _maxContent_Width, height: _scroll_bottom)
        
        loadButtons()
    }
    
    // MARK: 初始化按钮
    private func loadButtons() -> Void {
        
        if buttonTitleArray.count == 0 {
            return
        }
        
        if buttonTitleColorArray.count == 0 || buttonTitleColorArray.count < buttonTitleArray.count {
            let mutArr : NSMutableArray = NSMutableArray();
            for _ : NSInteger in 0..<buttonTitleArray.count {
                mutArr.add(UIColor.blue)
            }
            
            buttonTitleColorArray = mutArr.copy() as! [UIColor]
        }
        
        let buttonHeight : CGFloat = kBAAlert_ButtonHeight
        let buttonWidth = containerView.frame.width
        var top = containerView.frame.height - _button_totalHeight
        
        addLine(frame: CGRect(x: 0, y: top - 0.5, width: buttonWidth, height: 0.5), view: containerView)
        
        if buttonTitleColorArray.count > 0 {
            if buttonTitleArray.count == 1 {
                addButton(frame: CGRect(x: 0, y: top, width: buttonWidth, height: buttonHeight), title: buttonTitleArray[0], tag: 0, titleColor: buttonTitleColorArray[0])
            }
            else if buttonTitleArray.count == 2 {
                for i : NSInteger in 0..<buttonTitleArray.count {
                    addButton(frame: CGRect(x: (buttonWidth/2 * CGFloat(i)), y: top, width: buttonWidth/2, height: buttonHeight), title: buttonTitleArray[i], tag: i, titleColor: buttonTitleColorArray[i])
                }
                addLine(frame: CGRect(x: buttonWidth/2 - 0.5, y: top, width: 0.5, height: buttonWidth), view: containerView)
            }
            else {
                for i : NSInteger in 0..<buttonTitleArray.count {
                    addButton(frame: CGRect(x: 0, y: top, width: buttonWidth, height: buttonHeight), title: buttonTitleArray[i], tag: i, titleColor: buttonTitleColorArray[i])
                    top += buttonHeight
                    
                    if (buttonTitleArray.count - 1) != i {
                        addLine(frame: CGRect(x: 0, y: top, width: buttonWidth, height: 0.5), view: containerView)
                    }
                    
                }
                lineArray.enumerateObjects({ (lineView, index, nil) in
                    containerView.bringSubview(toFront: lineView as! UIView)
                })
            }
        }
    }
    
    private func addButton(frame: CGRect, title: String, tag: NSInteger, titleColor: UIColor) -> Void {
        let button = UIButton.init(frame: frame)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        
        if bgImageName != nil {
            button.setBackgroundImage(imageWithColor(color: .clear), for: .normal)
        }
        else {
            button.setBackgroundImage(imageWithColor(color: .white), for: .normal)
        }
        button.setBackgroundImage(imageWithColor(color: BAAlert_Color_RGBA(135, 140, 145, 0.45)), for: .highlighted)

        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        
        containerView.addSubview(button)
        buttonArray.add(button)
    }
    
    @objc private func buttonClicked(sender: UIButton) {
        self.endEditing(true)
        if (buttonActionBlock != nil) {
            buttonActionBlock!(sender.tag)
        }
    }
    
    private func addLine(frame: CGRect, view: UIView) -> Void {
        let lineView = UIView.init(frame: frame)
        lineView.backgroundColor = BAAlert_Color_Line
        
        view.addSubview(lineView)
        
        lineArray.add(lineView)
    }
    
    // MARK: 纯颜色转图片
    private func imageWithColor(color: UIColor) -> UIImage {
        return imageWithColor(color: color, size: CGSize(width: 1, height: 1))
    }
    
    private func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: 清楚所有 button
    private func ba_resetButtons() -> Void {
        
        buttonArray.forEach { (subView) in
            (subView as AnyObject).removeFromSuperview()
        }
        buttonArray.removeAllObjects()
        
        lineArray.forEach { (subView) in
            (subView as AnyObject).removeFromSuperview()
        }
        lineArray.removeAllObjects()
    }
    
    // MARK: 触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("触摸了边缘隐藏View！");
        for  touch : AnyObject in touches {
            
            let touchView : UIView = touch.view
            if !self.isTouchEdgeHide {
                NSLog("触摸了View边缘，但您未开启触摸边缘隐藏方法，请设置 isTouchEdgeHide 属性为 YES 后再使用！")
                return
            }
            if touchView.isKind(of: self.classForCoder) {
                ba_alertHidden()
            }
        }
    }

    // MARK: 获取屏幕截图
    private func getCurrentWindowImage() -> UIImage {
        UIGraphicsBeginImageContext((self.alertWindow.rootViewController?.view.bounds.size)!)
        self.alertWindow.rootViewController?.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // MARK: - setter / getter
    private lazy var containerView : UIImageView = {
        var containerView = UIImageView()
        containerView.isUserInteractionEnabled = true
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = kBAAlert_Radius
        containerView.backgroundColor = .white
        
        self.addSubview(containerView)
        return containerView
    }()
    
    private lazy var scrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = UIColor.white
        
        self.containerView.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var titleLabel : UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont.init(name: "FontNameAmericanTypewriterBold", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.text = self.title
        
        self.scrollView.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.image = self.image
        
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var messageLabel : UILabel = {
        var messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.backgroundColor = .clear
        messageLabel.textColor = .black
        messageLabel.text = self.message
        
        self.scrollView.addSubview(messageLabel)
        return messageLabel
    }()

    private lazy var blurImageView : UIImageView = {
        var blurImageView = UIImageView()
        blurImageView.contentMode = .scaleAspectFit
        blurImageView.clipsToBounds = true
        blurImageView.backgroundColor = .clear
        
        self.alertWindow.addSubview(blurImageView)
        return blurImageView
    }()
    
    private lazy var buttonTitleArray : [String] = {
        var buttonTitleArray = [String]()
        return buttonTitleArray
    }()

    private lazy var buttonTitleColorArray : [UIColor] = {
        var buttonTitleColorArray = [UIColor]()
        return buttonTitleColorArray
    }()

    private lazy var buttonArray : NSMutableArray = {
        var buttonArray = NSMutableArray()
        return buttonArray
    }()
    
    var lineArray : NSMutableArray = {
        var lineArray = NSMutableArray()
        return lineArray
    }()
    
    private lazy var alertWindow : UIWindow = {
        var alertWindow = UIApplication.shared.keyWindow
        alertWindow?.backgroundColor = BAAlert_Color_Translucent
        return alertWindow!
    }()
    
}
