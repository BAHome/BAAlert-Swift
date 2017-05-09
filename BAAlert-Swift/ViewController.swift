//
//  ViewController.swift
//  BAAlert-Swift
//
//  Created by boai on 2017/5/8.
//  Copyright © 2017年 boai. All rights reserved.
//

import UIKit

private
    let cellID = "cell"
    let titleMsg0 = "欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。\n对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。\n欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。\n对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。"
    let titleMsg1 = "欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。"
    let titleMsg2 = "对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。"



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let headerTitleLabel_font = UIFont.systemFont(ofSize: 13)
//    let headerTitleLabel_width = view.bounds.size.width - 20*2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupUI()
    }
    
    func setupUI() -> Void {
        
        self.title = "BAAlert"

        self.view.backgroundColor = UIColor.yellow
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let lableSize = BAKit_LabelSizeWithTextAndWidthAndFont(string: sectionArray[section], width: tableView.frame.size.width - 20*2, font: headerTitleLabel_font)
        
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
        
        let lableSize = BAKit_LabelSizeWithTextAndWidthAndFont(string: sectionArray[section], width: tableView.frame.size.width - 20*2, font: headerTitleLabel_font)
        headerTitleLabel.frame = CGRect(x: 20, y: 10, width: lableSize.width, height: lableSize.height)
        headerTitleLabel.text = (section != dataArray.count - 1) ? sectionArray[section] : nil;
        headerView.addSubview(headerTitleLabel)

        return headerView;
    }
    
    // MARK: - custom method
    override func viewDidLayoutSubviews() {
        
        self.tableView.frame = self.view.bounds
        
        self.tableView.reloadData();
    }

    // MARK: - setter / getter
    lazy var tableView:UITableView = {
        var tableView = UITableView(frame:CGRect(),style:UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        return tableView
    }()

    lazy var dataArray:[[String]] = {
        var data = [[String]]()
        data.append(["1、类似系统alert【加边缘手势消失】",
                     "2、自定义按钮颜色",
                     "3、自定义背景图片",
                     "4、内置图片和文字，可滑动查看",
                     "5、完全自定义alert"])
        data.append(["6、actionsheet",
                     "7、actionsheet带标题",
                     "8、actionsheet带标题带图片"])
        data.append(["DSAlert特点：\n1、手势触摸隐藏开关，可随时开关\n2、可以自定义背景图片、背景颜色、按钮颜色\n3、可以添加文字和图片，且可以滑动查看！\n4、横竖屏适配完美\n5、有各种炫酷动画展示你的alert\n6、理论完全兼容现有所有 iOS 系统版本"])
        return data
    }()

    lazy var sectionArray:[String] = {
        var data = [String]()
        data = ["alert 的几种日常用法，高斯模糊、炫酷动画，应有尽有！",
                "ActionSheet 的日常用法",
                ""]
        return data
    }()
}

