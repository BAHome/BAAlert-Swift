//
//  ViewController.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/8.
//  Copyright © 2017年 boai. All rights reserved.
//

import UIKit


private let cellID = "cell"

private let title0 = "温馨提示"
private let titleMsg0 = "欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。\n对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。\n欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。\n对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。"
private let titleMsg1 = "欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。"
private let titleMsg2 = "对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    private var alert1 : BAAlert?
    private var alert2 : BAAlert?
    private var alert3 : BAAlert?
    private var alert4 : BAAlert?
    private var alert5 : BAAlert?

    let headerTitleLabel_font = UIFont.systemFont(ofSize: 13)
//    let headerTitleLabel_width = view.bounds.size.width - 20*2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupUI()
    }
    
    func setupUI() -> Void {
        
        self.title = "BAAlert-Swift"

        self.view.backgroundColor = .white
        
    }
    
    // MARK: - UITableViewDelegate / UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = dataArray[section]
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = (indexPath.section == 0) ? UITableViewCellAccessoryType.disclosureIndicator : UITableViewCellAccessoryType.none
        cell.selectionStyle = (indexPath.section == 0) ? UITableViewCellSelectionStyle.default : UITableViewCellSelectionStyle.none
        
        let data = dataArray[indexPath.section];
        cell.textLabel?.text = data[indexPath.row];
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                self.alert1_func()
                break
            case 1:
                self.alert2_func()
                break
            case 2:
                self.alert3_func()
                break
            case 3:
                self.alert4_func()
                break
            case 4:
                self.alert5_func()
                break
                
            default:
                break
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                actionSheet1_func()
                break
            case 1:
                actionSheet2_func()
                break

            case 2:
                actionSheet3_func()
                break
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let lableSize = BAKit_LabelSizeWithTextAndWidthAndFont(string: sectionArray[section], width: tableView.frame.size.width - 20 * 2, font: headerTitleLabel_font)
        
        return lableSize.height + 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Float.leastNormalMagnitude)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()

        let headerTitleLabel = UILabel()
        
        headerTitleLabel.font = headerTitleLabel_font
        headerTitleLabel.textColor = UIColor.red
        headerTitleLabel.numberOfLines = 0
        
        let lableSize = BAKit_LabelSizeWithTextAndWidthAndFont(string: sectionArray[section], width: tableView.frame.size.width - 20 * 2, font: headerTitleLabel_font)
        headerTitleLabel.frame = CGRect(x: 20, y: 10, width: lableSize.width, height: lableSize.height)
        headerTitleLabel.text = sectionArray[section];
        headerView.addSubview(headerTitleLabel)
        
        return headerView;
    }
    
    // MARK: - custom method
    override func viewDidLayoutSubviews() {
        
        tableView.frame = self.view.bounds
        tableView.reloadData();
    }
    
    // MARK: - alert show
    private func alert1_func() -> Void{
        BAAlert.ba_alertShowWithTitle(title: title0, message: titleMsg0, image: nil, buttonTitleArray: ["取消", "确定1", "确定2", "确定3"], buttonTitleColorArray: [], configuration: { (tempView) in
            tempView.isTouchEdgeHide = true
            tempView.showAnimate = true
            tempView.blurEffectStyle = BAAlertBlurEffectStyle.BAAlertBlurEffectStyleLight
            alert1 = tempView
        }, block: { (index) in
            self.alert1?.ba_alertHidden()
            
            if index == 0 {
                
            }
            else {
                self.navigationController?.pushViewController(ViewController2(), animated: true)
            }
        })
    }
    
    private func alert2_func() -> Void {
        BAAlert.ba_alertShowWithTitle(title: title0, message: titleMsg1, image: nil, buttonTitleArray: ["取消", "跳转VC2"], buttonTitleColorArray: [.green, .red], configuration: { (tempView) in
            tempView.isTouchEdgeHide = true
            tempView.bgColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 0.3);
            tempView.animatingStyle = .BAAlertAnimatingStyleShake
            alert2 = tempView
        }, block: { (index) in
            self.alert2?.ba_alertHidden()
            
            if index == 0 {
                
            }
            else {
                self.navigationController?.pushViewController(ViewController2(), animated: true)
            }
        })
    }
    
    private func alert3_func() -> Void {
        BAAlert.ba_alertShowWithTitle(title: title0, message: titleMsg1, image: nil, buttonTitleArray: ["取消", "跳转VC2"], buttonTitleColorArray: [.green, .red], configuration: { (tempView) in
            tempView.isTouchEdgeHide = true
            tempView.bgImageName = "背景.jpg"
            tempView.animatingStyle = BAAlertAnimatingStyle.BAAlertAnimatingStyleFall
            alert3 = tempView
        }, block: { (index) in
            self.alert3?.ba_alertHidden()
            
            if index == 0 {
                
            }
            else {
                self.navigationController?.pushViewController(ViewController2(), animated: true)
            }
        })
    }
    
    private func alert4_func() -> Void {
        BAAlert.ba_alertShowWithTitle(title: title0, message: titleMsg1, image: UIImage.init(named: "美女.jpg"), buttonTitleArray: ["取消", "跳转VC2"], buttonTitleColorArray: [.green, .red], configuration: { (tempView) in
            tempView.isTouchEdgeHide = true
            tempView.bgImageName = "背景.jpg"
            alert4 = tempView
        }, block: { (index) in
            self.alert4?.ba_alertHidden()
            
            if index == 0 {
                
            }
            else {
                self.navigationController?.pushViewController(ViewController2(), animated: true)
            }
        })
    }
    
    private func alert5_func() -> Void{
        let customView = CustomView()
        customView.frame = CGRect(x: 50, y: 250, width: 250, height: 180)
        
        customView.buttonActionBlock = {[weak self]
            (index) in
        
            if index == 1
            {
                print("取消")
                self?.alert5?.ba_alertHidden()
            }
            else if index == 2
            {
                var temp2:BAAlert?
                BAAlert.ba_alertShowWithTitle(title: "温馨提醒", message: "请输入正确的密码", image: nil, buttonTitleArray:["确定"], buttonTitleColorArray: [UIColor.red], configuration: { (temp) in
                    temp2 = temp
                }, block: { (index) in
                    temp2?.ba_alertHidden()
                })
            }
        }
        
        BAAlert.ba_alertShowCustomView(customView: customView) { (tempView) in
            tempView.isTouchEdgeHide = true
            self.alert5 = tempView
        }
    }
    
    // MARK: - actionSheet show
    private func actionSheet1_func() -> Void{
        
        let dataArray:NSMutableArray = NSMutableArray()
        
        let contentArray:NSArray = ["微信支付", "支付宝", "预付款账户"]
        let subContentArray:NSArray = ["", "18588888888,18588888888,18588888888", "余额：￥480.00"]
        let imageArray:NSArray = ["123.png", "背景.jpg", "美女.jpg"]
        
        for index in 0..<contentArray.count {
            
            let model:BAActionSheetModel = BAActionSheetModel()
            model.imageUrl = imageArray[index] as! String
            model.content = contentArray[index] as! String
            model.subContent = subContentArray[index] as! String
            dataArray.add(model)
        }
        
        BAActionSheet.ba_actionSheetShowWithConfiguration(configuration: { (actionSheet) in
            
            actionSheet.dataArray = dataArray
            actionSheet.actionSheetType = .BAActionSheetTypeNormalLeft
            actionSheet.title = "支付方式"
            
            actionSheet.isTouchEdgeHide = true
            
            actionSheet.showAnimate = true
//            actionSheet.isShowCancelButton = true
            
        }) { [weak self] (actionSheet, indexPath, model) in
            self?.showWithTitle(model.content)

            print(model.content)
        }
    }
    
    private func actionSheet2_func() -> Void{
        
        let dataArray:NSMutableArray = NSMutableArray()
        
        let contentArray:NSArray = ["微信支付", "支付宝", "预付款账户"]
        
        for index in 0..<contentArray.count {
            
            let model:BAActionSheetModel = BAActionSheetModel()
            model.content = contentArray[index] as! String
            dataArray.add(model)
        }
        
        BAActionSheet.ba_actionSheetShowWithConfiguration(configuration: { (actionSheet) in
            
            actionSheet.dataArray = dataArray
            actionSheet.actionSheetType = .BAActionSheetTypeNormalCenter
            actionSheet.isShowCancelButton = true
//            actionSheet.isTouchEdgeHide = true
//            actionSheet.title = "支付方式"
            
            actionSheet.showAnimate = true
            actionSheet.animatingStyle = .BAAlertAnimatingStyleShake
            
        }) {[weak self] (actionSheet, indexPath, model) in
            
            self?.showWithTitle(model.content)

            print(model.content)
        }
    }
    
    private func actionSheet3_func() -> Void{
        
        let dataArray:NSMutableArray = NSMutableArray()
        
        let contentArray:NSArray = ["微信支付", "支付宝", "预付款账户", "中行"];
        let subContentArray:NSArray = [
        ["微信支付1", "微信支付2", "微信支付3"],
        ["支付宝1", "支付宝2", "支付宝3", "支付宝4"],
        [],
        ["中行1", "中行2", "中行3", "中行4", "中行5", "中行6", "中行7", "中行2", "中行3", "中行4", "中行5", "中行6", "中行7", "中行2", "中行3", "中行4", "中行5", "中行6", "中行7", "中行2", "中行3", "中行4", "中行5", "中行6", "中行7"]
        ];

        for i in 0..<contentArray.count {
            
            let model:BAActionSheetModel = BAActionSheetModel()
            model.content = contentArray[i] as! String
            
            let mutArray:NSMutableArray = NSMutableArray()
            let subContentArray2:NSArray = subContentArray[i] as! NSArray
            
            for j in 0..<(subContentArray[i] as AnyObject).count
            {
                let subContentModel:BAActionSheetSubContentModel = BAActionSheetSubContentModel()
                subContentModel.subContent = subContentArray2[j] as! String
                mutArray.add(subContentModel)
            }
            model.subContentArray = mutArray as! [BAActionSheetSubContentModel]
            
            dataArray.add(model)
        }
        
        BAActionSheet.ba_actionSheetShowWithConfiguration(configuration: { (actionSheet) in
            
            actionSheet.dataArray = dataArray
            actionSheet.actionSheetType = .BAActionSheetTypeExpand
//            actionSheet.isShowCancelButton = true
            actionSheet.isTouchEdgeHide = true
//            actionSheet.title = "支付方式"
            
        }) { [weak self] (actionSheet, indexPath, model) in
            
            if indexPath == nil{
                self?.showWithTitle(model.content)
            }else{
               let subModel:BAActionSheetSubContentModel = model.subContentArray[indexPath!.row]
                self?.showWithTitle(subModel.subContent)
            }
        }
    }


    private func showWithTitle(_ title:String) -> Void{
        let alertVC:UIAlertController = UIAlertController.init(title: "提醒", message: title, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction:UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            
        }
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - setter / getter
    lazy var tableView:UITableView = {
        var tableView = UITableView(frame:CGRect(),style:UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
        tableView.backgroundColor = BAAlert_Color_gray11
        
        self.view.addSubview(tableView)
        return tableView
    }()

    private lazy var dataArray:[[String]] = {
        var data = [[String]]()
        data.append(["1、类似系统alert【加边缘手势消失】",
                     "2、自定义按钮颜色",
                     "3、自定义背景图片",
                     "4、内置图片和文字，可滑动查看",
                     "5、完全自定义alert"])
        data.append(["1、actionsheet 默认样式：title、subTitle、image",
                     "2、actionsheet custom样式，类似于微博的 actionsheet",
                     "3、actionsheet 展开选择样式，可以展开收回"])
        data.append(["1、手势触摸隐藏开关，可随时开关\n2、可以自定义背景图片、背景颜色、按钮颜色\n3、可以添加文字和图片，且可以滑动查看！\n4、横竖屏适配完美\n5、有各种炫酷动画展示你的alert\n6、理论完全兼容现有所有 iOS 系统版本"])
        return data
    }()

    private lazy var sectionArray:[String] = {
        var data = [String]()
        data = ["alert 的几种日常用法，高斯模糊、炫酷动画，应有尽有！",
                "ActionSheet 的日常用法",
                "BAAlert特点"]
        return data
    }()
}

