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

class FBTimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var savedEventId : String = ""
    
    fileprivate lazy var timelineVM : FBTimelineViewModel = FBTimelineViewModel()
    
    //顶部列表选择器
    fileprivate lazy var timelineSegment : UIView = {
        //背景
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
    
    fileprivate lazy var firstTitle : UILabel = {
        var firstTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        firstTitle.text = "全 部"
        firstTitle.font = UIFont.systemFont(ofSize: 18)
        firstTitle.textColor = UIColor.orange
        firstTitle.textAlignment = .center

        return firstTitle
    }()
    
    fileprivate lazy var secondTitle : UILabel = {
        var secondTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        secondTitle.text = "关 注"
        secondTitle.font = UIFont.systemFont(ofSize: 18)
        secondTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
        secondTitle.textAlignment = .center
        
        return secondTitle
    }()
    
    fileprivate lazy var timelineCVC : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.view.bounds.width - 20, height: 100)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        //判断机型, 设置不同的上下 inset
        let bigger = providMoreVerticalSpace()
        
        layout.sectionInset = UIEdgeInsets(top: bigger ? 0 : 5, left: 10, bottom: 20, right: 10)
        
       let timelineCVC = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        timelineCVC.delegate = self
        timelineCVC.dataSource = self
        timelineCVC.tag = 2
        timelineCVC.backgroundColor = UIColor.white
        timelineCVC.register(FBTimelineCollectionViewCell.self, forCellWithReuseIdentifier: kTimelineCellID)
        
        return timelineCVC
    }()
    
    fileprivate lazy var baseScrollowView : UIScrollView =  {
        let baseScrollowView = UIScrollView.init(frame: CGRect(x: 0, y: 65, width: self.view.bounds.width, height: self.view.bounds.height))
        baseScrollowView.contentSize = CGSize(width: self.view.bounds.width * 2, height: self.view.bounds.height - 60)
        baseScrollowView.isPagingEnabled = true
        baseScrollowView.delegate = self
        baseScrollowView.tag = 1
        baseScrollowView.showsHorizontalScrollIndicator = false
        return baseScrollowView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateContent()
        loadData()
    }
    
}

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
        
        timelineSegment.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(25)
            make.top.equalTo(25)
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
            make.centerY.equalTo(timelineSegment.snp.centerY)
            make.centerX.equalTo(timelineSegment.snp.left).offset((self.view.bounds.size.width - 50) / 4)
        }
        secondTitle.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(timelineSegment.snp.centerY)
            make.centerX.equalTo(timelineSegment.snp.right).offset(-(self.view.bounds.size.width - 50)/4)
        }
    }
    
    
}

extension FBTimelineViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelineVM.timelineModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FBTimelineCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kTimelineCellID, for: indexPath) as! FBTimelineCollectionViewCell
        
        cell.cellModel = timelineVM.timelineModels[indexPath.item]
        
        return cell
    }
    
    //Item 选中方法,
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //保存日历事件
       let date = combineDate(date: self.timelineVM.timelineModels[indexPath.item].date, time: self.timelineVM.timelineModels[indexPath.item].time)
        addEvent(title: self.timelineVM.timelineModels[indexPath.item].title, startDate: date)
    }

}

//获得数据
extension FBTimelineViewController {
    fileprivate func loadData() {
        timelineVM.loadTimelineData(preDate: "") {
            self.timelineCVC.reloadData()
        }
    }
}


//保存日历事件
extension FBTimelineViewController {
    
    @objc func tapFirstTitle() {
        if slideBar.center.x > timelineSegment.frame.size.width / 2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.slideBar.center.x = self.timelineSegment.frame.size.width / 2 - 67.5
                //set title color
                self.firstTitle.textColor = UIColor.orange
                self.secondTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
                self.baseScrollowView.contentOffset.x = 0
            })
            
        }
    }
    @objc func tapSeconTitle() {
        if slideBar.center.x < timelineSegment.frame.size.width / 2 {
            UIView.animate(withDuration: 0.2, animations: {
                self.slideBar.center.x = 67.5 + self.timelineSegment.frame.size.width / 2
                //set title color
                self.firstTitle.textColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
                self.secondTitle.textColor = UIColor.orange
                self.baseScrollowView.contentOffset.x = self.view.frame.size.width
            })
        }
    }
    
    //将字符串转成 NSDate 格式
    func combineDate(date : String, time : String) -> Date {
        let entireDate = date + time
        let format : DateFormatter = DateFormatter()
        format.dateFormat = "yyyy-MM-ddHH:mm"
        format.timeZone = TimeZone(abbreviation: "CTS")
        let date : Date = format.date(from: entireDate)!
        return date
    }
    
    //创建事件
    func addEvent( title : String, startDate : Date) {
        let eventStore = EKEventStore()
        let endDate = startDate.addingTimeInterval(60 * 110)//一场比赛的时间
        //判断权限
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: { (Bool, Error) in
                self.createEvent(eventStore: eventStore, title: title, startDate: startDate, endDate: endDate)
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
        } catch {
            print("保存失败")
        }
    }
}

extension FBTimelineViewController {
    fileprivate func providMoreVerticalSpace() -> Bool {
        let currentDeviceH = UIScreen.main.bounds.height
        let currentDeviveW = UIScreen.main.bounds.width
        if currentDeviceH / currentDeviveW > 2 {
            return true
        }else {
            return false
        }
    }
}


//update slider bar center
extension FBTimelineViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if 1 == scrollView.tag {
            if !(scrollView.contentOffset.x < 0) && !(scrollView.contentOffset.x > self.view.frame.size.width) {
                slideBar.center.x = 67.5 + (timelineSegment.frame.size.width / self.view.frame.size.width) * scrollView.contentOffset.x / 2
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












