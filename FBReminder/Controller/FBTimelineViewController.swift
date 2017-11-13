//
//  FBTimelineViewController.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/10/11.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//

import UIKit
import SwiftyJSON
import PullToRefreshKit
import EventKit
import SnapKit

private let kTimelineCellID = "kTimelineCellID"
private let kBoundsWidth = "self.view.bounds.width"
private let kBoundsHeight = "self.view.bounds.height"


fileprivate var timeLineItemArray : NSMutableArray = NSMutableArray()
//查询所有日历事件后的标题数组, 用于区别已经添加的事件
fileprivate var localCalenderEventArray : NSMutableArray = NSMutableArray()

class FBTimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var savedEventId : String = ""
    
    fileprivate lazy var timelineVM : FBTimelineViewModel = FBTimelineViewModel()
    fileprivate lazy var userDefault : UserDefaults = UserDefaults.standard
    fileprivate lazy var eventStore : EKEventStore = EKEventStore()
    
    //顶部列表选择器
    fileprivate lazy var timelineSegment : UIView = {
        let timelineSegment = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        timelineSegment.backgroundColor = UIColor(red: 230/255, green: 229/255, blue: 228/255, alpha: 1.0)
        timelineSegment.layer.borderWidth = 1
        timelineSegment.layer.cornerRadius = 6
        timelineSegment.layer.borderColor = UIColor(red: 213/255, green: 212/255, blue: 211/255, alpha: 1.0).cgColor
        
        return timelineSegment
    }()
    
    //滑块
    fileprivate lazy var slideBar : UIView = {
        var slideBar : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        slideBar.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 246/255, alpha: 1.0)
        slideBar.layer.borderColor = UIColor(red: 216/255, green: 214/255, blue: 213/255, alpha: 1.0).cgColor
        slideBar.layer.borderWidth = 1
        slideBar.layer.cornerRadius = 5
        return slideBar
    }()
    
    //标题一
    fileprivate lazy var firstTitle : UILabel = {
        var firstTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        firstTitle.text = "全 部"
        firstTitle.font = UIFont.systemFont(ofSize: 18)
        firstTitle.textColor = UIColor.orange
        firstTitle.textAlignment = .center
        return firstTitle
    }()
    //标题二
    fileprivate lazy var secondTitle : UILabel = {
        var secondTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        secondTitle.text = "关 注"
        secondTitle.font = UIFont.systemFont(ofSize: 18)
        secondTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
        secondTitle.textAlignment = .center
        return secondTitle
    }()
    
    //列表底部的scrollView
    fileprivate lazy var baseScrollowView : UIScrollView =  {
        let bigger = providMoreVerticalSpace()
        let baseScrollowView = UIScrollView.init(frame: CGRect(x: 0, y: bigger ? 85 : 65, width: self.view.bounds.width, height: self.view.bounds.height))
        baseScrollowView.contentSize = CGSize(width: self.view.bounds.width * 2, height: self.view.bounds.height - 60)
        baseScrollowView.isPagingEnabled = true
        baseScrollowView.delegate = self
        baseScrollowView.tag = 1
        baseScrollowView.showsHorizontalScrollIndicator = false
        return baseScrollowView
    }()
    
    //时间线, 列表
    fileprivate lazy var timelineCVC : UICollectionView = {
        let bigger = providMoreVerticalSpace()
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.view.bounds.width - 20, height: 90)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 10)
        
        let timelineCVC = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-(bigger ? 85 : 65)), collectionViewLayout: layout)
        timelineCVC.delegate = self
        timelineCVC.dataSource = self
        timelineCVC.tag = 2
        timelineCVC.backgroundColor = UIColor.white
        timelineCVC.register(FBTimelineCollectionViewCell.self, forCellWithReuseIdentifier: kTimelineCellID)
        
        return timelineCVC
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //验证日历权限
        verifyCalenderPermission()
        //查询日历时间, 添加到数组中, 以供对比
        getAllcalendarEvents()
        //设置页面UI
        setupUI()
        //设置约束
        updateContent()
        //请求加载数据
        loadData()
    }
    
}


//页面布局
extension FBTimelineViewController {
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(timelineSegment)
        
        timelineSegment.addSubview(slideBar)
        timelineSegment.addSubview(firstTitle)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(FBTimelineViewController.tapFirstTitle))
        firstTitle.addGestureRecognizer(tapGesture1)
        firstTitle.isUserInteractionEnabled = true
        timelineSegment.addSubview(secondTitle)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(FBTimelineViewController.tapSeconTitle))
        secondTitle.addGestureRecognizer(tapGesture2)
        secondTitle.isUserInteractionEnabled = true
        
        view.addSubview(baseScrollowView)
        
        baseScrollowView.addSubview(timelineCVC)
        
        //添加上拉刷新
        timelineCVC.setUpFooterRefresh {
            self.timelineVM.loadTimelineData(preDate: self.timelineVM.preDataBegin, finishedCallback: {
                self.timelineCVC.endFooterRefreshing()
                self.timelineCVC.reloadData()
            })
        }
    }
    
    fileprivate func updateContent() {
        let bigger = providMoreVerticalSpace()
        timelineSegment.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(25)
            make.top.equalTo(bigger ? 45 : 25)
            make.width.equalTo(self.view.bounds.size.width - 50)
            make.height.equalTo(35)
        }
        
        slideBar.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalTo(timelineSegment.snp.centerY)
            make.width.equalTo((self.view.bounds.width - 50) / 2 - 4)
            make.height.equalTo(31)
            make.left.equalTo(timelineSegment.snp.left).offset(2)
        })
        
        
        firstTitle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(slideBar.snp.width)
            make.centerY.equalTo(timelineSegment.snp.centerY)
            make.centerX.equalTo(timelineSegment.snp.left).offset((self.view.bounds.size.width - 50) / 4)
        }
        secondTitle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(slideBar.snp.width)
            make.centerY.equalTo(timelineSegment.snp.centerY)
            make.centerX.equalTo(timelineSegment.snp.right).offset(-(self.view.bounds.size.width - 50)/4)
        }
    }
}


//CollectionView代理方法
extension FBTimelineViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelineVM.timelineModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FBTimelineCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kTimelineCellID, for: indexPath) as! FBTimelineCollectionViewCell
        
        cell.cellModel = timelineVM.timelineModels[indexPath.item]

        //判断这个数据是否已经保存到日历中了,区别对待一下
        if localCalenderEventArray.contains(cell.cellModel?.title as Any) {
            cell.alarmIcon.image = UIImage(named: "alarm_selected")
        }else {
            //这里如果不设置未选中的颜色, 就会出现"被选中"的问题
            cell.alarmIcon.image = UIImage(named: "alarm")
        }
        return cell
    }
    
    //Item 选中方法,
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //保存日历事件
        let date = combineDate(date: self.timelineVM.timelineModels[indexPath.item].date, time: self.timelineVM.timelineModels[indexPath.item].time)
        //添加或者删除日历
        //日历中已经存在该事件
        if localCalenderEventArray.contains(self.timelineVM.timelineModels[indexPath.item].title as Any) {
            //如果已经存在了, 就先从数组中删除, 在从日历中删除
            localCalenderEventArray.remove(self.timelineVM.timelineModels[indexPath.item].title)
            let eventID = userDefault.object(forKey: self.timelineVM.timelineModels[indexPath.item].title)
            //从系统日历中删除
            if eventID != nil {
                deleteEvent(eventID: eventID as! String)
            }
            //刷新数组
            getAllcalendarEvents()
            //刷新UI
            self.timelineCVC.reloadData()
        }else {//还没有这个事件, 执行事件存储
            //先添加事件到日历
            addEvent(title: self.timelineVM.timelineModels[indexPath.item].title, startDate: date)
            //在刷新事件数组
            getAllcalendarEvents()
            //在刷新界面,设置选中Cell的外观
            self.timelineCVC.reloadData()
        }
    }
}


//日历事件处理
extension FBTimelineViewController {
    //请求系统日历权限
    fileprivate func verifyCalenderPermission() {
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: { (Bool, Error) in
            })
        }
    }
    
    //查询系统日历事件
    fileprivate func getAllcalendarEvents() {
        localCalenderEventArray.removeAllObjects()
        //过滤掉节假日等系统事件
        let calendars = eventStore.calendars(for: .event).filter({
            (calender) -> Bool in
            return calender.type == .local || calender.type == .calDAV
        })
        //获取全部日历(后90天)
        let startDate = Date().addingTimeInterval(0)
        let endDate = Date().addingTimeInterval(3600 * 24 * 90)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        if let eV = eventStore.events(matching: predicate) as [EKEvent]! {
            for i in eV {
                localCalenderEventArray.add(i.title.description)
            }
        }
    }
    
    
    
    //创建事件
    func addEvent( title : String, startDate : Date) {
        let endDate = startDate.addingTimeInterval(60 * 110)//一场比赛的时间
        //判断权限
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: { (Bool, Error) in
                self.createEvent(eventStore: self.eventStore, title: title, startDate: startDate, endDate: endDate)
            })
        }else {
            createEvent(eventStore: eventStore, title: title, startDate: startDate, endDate: endDate)
        }
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        let alarmDate = startDate.addingTimeInterval(-60 * 10)
        let firtstAlarm = EKAlarm(absoluteDate: alarmDate)
        let secondAlarm = EKAlarm(absoluteDate: startDate)
        event.addAlarm(firtstAlarm)
        event.addAlarm(secondAlarm)
        
        do {
            try eventStore.save(event, span: .thisEvent)
        
            savedEventId = event.eventIdentifier
            userDefault.setValue(savedEventId, forKey: event.title)
        } catch {
            print("保存失败")
        }
    }
    
    
    //通过EventID 找到指定的日历事件, 然后删除
    func deleteEvent(eventID : String) {
        let event = eventStore.event(withIdentifier: eventID)
        do {
            if (event != nil) {
                try eventStore.remove(event!, span: .futureEvents)
            }
        } catch  {
            print("删除失败")
        }
    }
}



//标题选择器和列表的交互操作
extension FBTimelineViewController {
    //点击第一个标题, 滚动列表
    @objc func tapFirstTitle() {
        if slideBar.center.x > timelineSegment.frame.size.width / 2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.slideBar.center.x = self.timelineSegment.frame.size.width / 2 - (self.slideBar.frame.size.width/2 + 2)
                //set title color
                self.firstTitle.textColor = UIColor.orange
                self.secondTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
                self.baseScrollowView.contentOffset.x = 0
            })
            
        }
    }
    //点击第二个标题, 滚动列表
    @objc func tapSeconTitle() {
        if slideBar.center.x < timelineSegment.frame.size.width / 2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.slideBar.center.x = (self.slideBar.frame.size.width/2 + 2) + self.timelineSegment.frame.size.width / 2
                //set title color
                self.firstTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
                self.secondTitle.textColor = UIColor.orange
                self.baseScrollowView.contentOffset.x = self.view.frame.size.width
            })
        }
    }
    //滚动列表, 切换标题位置及文字颜色
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if 1 == scrollView.tag {
            if !(scrollView.contentOffset.x < 0) && !(scrollView.contentOffset.x > self.view.frame.size.width) {
                slideBar.center.x = slideBar.frame.size.width/2 + 2 + (timelineSegment.frame.size.width / self.view.frame.size.width) * scrollView.contentOffset.x / 2
                if slideBar.center.x > timelineSegment.frame.size.width / 2 {
                    firstTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
                    secondTitle.textColor = UIColor.orange
                }else {
                    firstTitle.textColor = UIColor.orange
                    secondTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
                }
            }else {
            }
        }
    }
}


//工具方法
extension FBTimelineViewController {
    //加载数据
    fileprivate func loadData() {
        timelineVM.loadTimelineData(preDate: "") {
            self.timelineCVC.reloadData()
        }
    }
    
    //判断机型, 是否提供更多的上下空间
    fileprivate func providMoreVerticalSpace() -> Bool {
        let currentDeviceH = UIScreen.main.bounds.height
        let currentDeviveW = UIScreen.main.bounds.width
        if currentDeviceH / currentDeviveW > 2 {
            return true
        }else {
            return false
        }
    }
    
    //将字符串转成 NSDate 格式
    fileprivate func combineDate(date : String, time : String) -> Date {
        let entireDate = date + time
        let format : DateFormatter = DateFormatter()
        format.dateFormat = "yyyy-MM-ddHH:mm"
        format.timeZone = TimeZone(abbreviation: "CTS")
        let date : Date = format.date(from: entireDate)!
        return date
    }
}









