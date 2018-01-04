//
//  BAActionSheet.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/13.
//  Copyright © 2017年 boai. All rights reserved.
//

import UIKit

/*! BAActionSheet 类型，默认：1 */
enum BAActionSheetType:NSInteger {
   case BAActionSheetTypeNormalLeft = 1
   case BAActionSheetTypeNormalCenter
   case BAActionSheetTypeExpand
}

/*!
 * 按钮点击事件回调
 */
typealias BAActionSheet_ConfigBlock = (_ tempView : BAActionSheet) -> Void
typealias BAActionSheet_ActionBlock = (_ tempView : BAActionSheet,_ indexPath:NSIndexPath?,_ model:BAActionSheetModel) -> Void


private let kCellID = "BAActionSheetCell"

class BAActionSheet: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - 公开属性
    /*! 是否开启边缘触摸隐藏 alert 默认：NO */
    var isTouchEdgeHide : Bool = false
    
    /*! 是否开启进出场动画 默认：NO，如果 YES ，并且同步设置进出场动画枚举为默认值：1 */
    var showAnimate : Bool = false
    
    /*! 设置动画时view不处理点击事件 */
    var isAnimate : Bool = false
    
    /*! 是否显示底部取消Button */
    var isShowCancelButton : Bool = false
    
    /*! 设置标题 */
    var title : String = ""
    
    /*! 设置选择行数 */
    var selectIndexPath : NSIndexPath?

    /*! 进出场动画枚举 默认：1 ，并且默认开启动画开关 */
    var animatingStyle : BAAlertAnimatingStyle = .BAAlertAnimatingStyleScale
    
    /*! 进出场动画枚举 默认：1 ，并且默认开启动画开关 */
    var actionSheetType : BAActionSheetType?

    /*! 点击事件回调 */
    var actionBlock:BAActionSheet_ActionBlock?
    
    /*! actionSheet要显示的数据*/
    var dataArray:NSMutableArray = NSMutableArray()

    // MARK: - 私有属性
    /*! actionSheet要显示的数据*/
    private var expansionSection:NSInteger = 100000000
    
    /*! tableView初始化高度*/
    private var tableHeight:CGFloat?
    
    // MARK: - 公开方法
    /*!
     *
     *  @param title             标题内容(可空)
     *  @param style             样式
     *  @param contentArray      选项数组(NSString数组)
     *  @param imageArray        图片数组(UIImage数组)
     *  @param contentColorArray 内容颜色数组
     *  @param titleColor    titleColor
     *  @param configuration 属性配置：如 bgColor、buttonTitleColor、isTouchEdgeHide...
     *  @param actionBlock  block回调点击的选项
     */
    static func ba_actionSheetShowWithConfiguration(configuration : BAActionSheet_ConfigBlock, actionBlock : @escaping BAActionSheet_ActionBlock) -> Void {
        
        let tempView = BAActionSheet.init(frame: CGRect())
        configuration(tempView)
        tempView.actionBlock = actionBlock
        tempView.ba_actionSheetShow()
    }
    
    
    /*!
     *  隐藏 BAActionSheet
     */
    func ba_actionSheetHidden() -> Void {
        

        if showAnimate {
            dismissAnimationView(animationView: tableView)
        }
        else
        {
            ba_removeSelf_actionSheet()
        }

    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupCommonUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 私有属性

    // MARK: - UITableViewDelegate / UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if  actionSheetType == .BAActionSheetTypeExpand {
           return dataArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  actionSheetType == .BAActionSheetTypeExpand {
            
            if expansionSection == section {
                let model:BAActionSheetModel = dataArray[section] as! BAActionSheetModel
                return model.subContentArray.count
            }
            return 0
           
        }
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:BAActionSheetCell? = tableView.dequeueReusableCell(withIdentifier: kCellID) as? BAActionSheetCell
       
        if cell == nil {
            
            cell = BAActionSheetCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: kCellID) 
        }
         cell?.actionSheetType = actionSheetType!
        
        if actionSheetType == .BAActionSheetTypeExpand {
            let model:BAActionSheetModel = dataArray[indexPath.section] as! BAActionSheetModel
            
            let subModel:BAActionSheetSubContentModel = model.subContentArray[indexPath.row] 
            cell?.textLabel?.text = subModel.subContent
            cell?.textLabel?.textColor = UIColor.init(red: 173 / 255.0, green: 180 / 255.0, blue: 190 / 255.0, alpha: 1)
            cell?.backgroundColor = UIColor.init(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)

        }
        else
        {
            let model:BAActionSheetModel = dataArray[indexPath.row] as! BAActionSheetModel
            cell?.imageView?.image = UIImage.init(named: model.imageUrl as String)
            cell?.textLabel?.text = model.content as String
            cell?.detailTextLabel?.text = model.subContent as String
            
            if actionSheetType == .BAActionSheetTypeNormalLeft {
                if (selectIndexPath == nil && indexPath.row == 0 && indexPath.section == 0)||(selectIndexPath == indexPath as NSIndexPath) {
                    cell?.accessoryType = UITableViewCellAccessoryType.checkmark;
                    selectIndexPath = indexPath as NSIndexPath
                }
            }
  
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndexPath = indexPath as NSIndexPath
        
        if (actionBlock != nil) {
            
            let model:BAActionSheetModel?
            
            if actionSheetType == .BAActionSheetTypeExpand {
                model = dataArray[indexPath.section] as? BAActionSheetModel
            }
            else{
                model = dataArray[indexPath.row] as? BAActionSheetModel
            }
            
            actionBlock!(self,indexPath as NSIndexPath,model!)
        }
        ba_actionSheetHidden()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if actionSheetType == .BAActionSheetTypeExpand {
            return 40
        }
        
        return (section == 0) ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView:UIView = UIView()
        headView.backgroundColor = UIColor.white
        
        let titleLabel:UILabel = UILabel()
        titleLabel.frame = CGRect(x:10,y:0,width:self.frame.width - 20,height:40)
        //titleLabel.textAlignment = NSTextAlignment.center
        let model:BAActionSheetModel = dataArray[section] as! BAActionSheetModel
        titleLabel.text = model.content
        headView.addSubview(titleLabel)
        
        
        let bottomImageView:UIImageView = UIImageView()
        bottomImageView.frame = CGRect(x:self.frame.width - 30,y:12.5 ,width:15 ,height:15 )
        bottomImageView.contentMode = UIViewContentMode.scaleAspectFit
        bottomImageView.image = UIImage.init(named:"BAAlert.bundle/Images/arow_down")
        headView.addSubview(bottomImageView)
        
        if model.subContentArray.count == 0 {
            bottomImageView.isHidden = true
        }

        let button:UIButton = UIButton()
        button.frame = CGRect(x:0,y:0,width:self.frame.width,height:40)
        button.addTarget(section, action: #selector(handleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        button.tag = section
        headView.addSubview(button)
        return headView
    }
    
    @objc private func handleButtonAction(sender:UIButton)
    {
        let model:BAActionSheetModel = dataArray[sender.tag] as! BAActionSheetModel
        if model.subContentArray.count == 0 {
            if (actionBlock != nil) {
                actionBlock!(self,nil,model)
            }
            ba_actionSheetHidden()
        }
        else
        {
            if sender.tag == expansionSection{
                expansionSection = 100000000
            }else{
                expansionSection = sender.tag
            }
            tableView.reloadData()
            sutupTableHeight()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat(CGFloat.leastNormalMagnitude)
    }
    
    // MARK: - custom method
    private func setupCommonUI() {
        self.backgroundColor = BAAlert_Color_Translucent
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationRotateAction(noti:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.tableView.reloadData()
    }
    
    @objc private func handleDeviceOrientationRotateAction(noti : NSNotification) -> Void {
        ba_layoutSubviews()
    }
    
    private func ba_layoutSubviews() {
        
        self.frame = UIScreen.main.bounds
        actionSheetWindow.frame = UIScreen.main.bounds
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        sutupTableHeight()
       
    }
    
    private func sutupTableHeight() -> Void {
        var min_x : CGFloat = 0.0
        var min_y : CGFloat = 0.0
        var min_w : CGFloat = 0.0
        var min_h : CGFloat = 0.0
        
        min_x = 0
        min_w = self.frame.width
        
        if !title.isEmpty {
            min_h += 40
            tableView.tableHeaderView = tableHeaderView
            headViewTitle.frame = CGRect(x:10,y:0,width:self.frame.width - 20,height:40)
        }
        
        if isShowCancelButton {
            min_h += 50
            tableView.tableFooterView = tableFooterView
            cancelButton.frame = CGRect(x:0,y:10,width:self.frame.width,height:40)
        }
        
        min_h = min(self.frame.height, tableView.contentSize.height)
        
        min_y = self.frame.height - min_h
        
        tableView.frame = CGRect(x : min_x, y : min_y, width : min_w, height : min_h)
        if actionSheetType == .BAActionSheetTypeExpand {
            tableView.reloadData()
            if min_y == 0.0 {
                tableView.isScrollEnabled = true
            }
        }

        
    }
    
    private func ba_actionSheetShow() -> Void {
        actionSheetWindow.addSubview(self)
         ba_layoutSubviews()
        if showAnimate {
            showAnimationWithView(animationView: tableView)
        }
    }
    
    @objc private func ba_removeSelf_actionSheet() -> Void  {
        tableView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    // MARK: 触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isAnimate {
            NSLog("触摸了边缘隐藏View！");
            for  touch : AnyObject in touches {
                
                let touchView : UIView = touch.view
                if !self.isTouchEdgeHide {
                    NSLog("触摸了View边缘，但您未开启触摸边缘隐藏方法，请设置 isTouchEdgeHide 属性为 YES 后再使用！")
                    return
                }
                if touchView.isKind(of: self.classForCoder) {
                    ba_removeSelf_actionSheet()
                }
            }
        }
    }
    
    
    @objc private func cancelButtonClickedAction(sender:UIButton){
        ba_removeSelf_actionSheet()

    }
    
    // MARK: 进场动画
    private func showAnimationWithView(animationView : UIView) -> Void {
        isAnimate = true
        if animatingStyle == .BAAlertAnimatingStyleScale {
            animationView.scaleAnimationShowFinishAnimation(finish: {[weak self] () in
                
                self?.isAnimate = false
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleShake {
            animationView.layer.shakeAnimationWithDuration(duration: 0.35, radius: 16.0, repeatCount: 1.0, finish: { [weak self] () in
                
                self?.isAnimate = false
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleFall {
            animationView.layer.fallAnimationWithDuration(duration: 0.35, finish: {[weak self] () in
                
                self?.isAnimate = false
            })
        }
    }
    
    private func dismissAnimationView(animationView : UIView) -> Void {
        
        isAnimate = true
        if animatingStyle == .BAAlertAnimatingStyleScale {
            animationView.scaleAnimationDismissFinishAnimation(finish: {[weak self] () in
                self?.isAnimate = false
                self?.ba_removeSelf_actionSheet()
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleShake {
            animationView.layer.floatAnimationWithDuration(duration: 0.35, finish: {[weak self] () in
                self?.isAnimate = false
                self?.ba_removeSelf_actionSheet()
            })
        }
        else if animatingStyle == .BAAlertAnimatingStyleFall {
            animationView.layer.floatAnimationWithDuration(duration: 0.35, finish: {[weak self] () in
                self?.isAnimate = false
                self?.ba_removeSelf_actionSheet()
            })
        }
    }
    
    // MARK: - setter / getter
    private lazy var tableView : UITableView = {
        var tableView = UITableView(frame : CGRect(), style : UITableViewStyle.plain)
        tableView.backgroundColor = BAAlert_Color_gray11
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
        return tableView
    }()
    
    private lazy var tableHeaderView:UIView = {
        
        var tableHeaderView = UIView()
        tableHeaderView.frame = CGRect(x:0,y:0,width:self.frame.width,height:40)

        return tableHeaderView
    }()
    
    private lazy var headViewTitle:UILabel = {
        
        var headViewTitle:UILabel = UILabel()
        headViewTitle.frame = CGRect(x:10,y:0,width:self.frame.width - 20,height:40)
        headViewTitle.text = self.title
        headViewTitle.textAlignment = NSTextAlignment.center
        self.tableHeaderView.addSubview(headViewTitle)
        
        return headViewTitle
    }()

    private lazy var tableFooterView:UIView = {
        
        var tableFooterView = UIView()
        tableFooterView.frame = CGRect(x:0,y:0,width:self.frame.width,height:50)
        
        return tableFooterView
    }()
    
    private lazy var cancelButton:UIButton = {
        var cancelButton = UIButton()
        cancelButton.frame = CGRect(x:0,y:10,width:self.tableView.frame.width,height:40)
         cancelButton.setTitle("取消", for: UIControlState.normal)
         cancelButton.setTitleColor(UIColor.black,for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClickedAction(sender:)), for: UIControlEvents.touchUpInside)
        cancelButton.backgroundColor = UIColor.white
        self.tableFooterView.addSubview(cancelButton)
        
        return cancelButton
    }()
    
    private lazy var actionSheetWindow : UIWindow = {
        var actionSheetWindow = UIApplication.shared.keyWindow
        actionSheetWindow?.backgroundColor = BAAlert_Color_Translucent
        
        return actionSheetWindow!
    }()
    }


class BAActionSheetModel: NSObject{
    var imageUrl:String = ""
    var content:String = ""
    var subContent:String = ""
    var subContentArray:[BAActionSheetSubContentModel] = NSMutableArray() as! [BAActionSheetSubContentModel]
}

class BAActionSheetSubContentModel: NSObject{
    var subContent:String = ""
}
