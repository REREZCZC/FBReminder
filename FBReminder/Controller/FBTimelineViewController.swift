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

private let kTimelineCellID = "kTimelineCellID"
private let kBoundsWidth = "self.view.bounds.width"
private let kBoundsHeight = "self.view.bounds.height"


fileprivate var timeLineItemArray : NSMutableArray = NSMutableArray()

class FBTimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var savedEventId : String = ""
    
    fileprivate lazy var timelineVM : FBTimelineViewModel = FBTimelineViewModel()
    fileprivate lazy var timelineCVC : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.view.bounds.width - 20, height: 100)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        //判断机型, 设置不同的上下 inset
        let bigger = providMoreVerticalSpace()
        
        layout.sectionInset = UIEdgeInsets(top: bigger ? 0 : 10, left: 10, bottom: 20, right: 10)
        
        
       let timelineCVC = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        timelineCVC.delegate = self
        timelineCVC.dataSource = self
        timelineCVC.backgroundColor = UIColor.white
        timelineCVC.register(FBTimelineCollectionViewCell.self, forCellWithReuseIdentifier: kTimelineCellID)
        
        return timelineCVC
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
}

extension FBTimelineViewController {
    fileprivate func setupUI() {
        view.addSubview(timelineCVC)
        //添加上拉刷新
        timelineCVC.setUpFooterRefresh {
            self.timelineVM.loadTimelineData(preDate: self.timelineVM.preDataBegin, finishedCallback: {
                self.timelineCVC.endFooterRefreshing()
                self.timelineCVC.reloadData()
            })
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


//监听滑动偏移量禁止上拉
extension FBTimelineViewController {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if timelineCVC.contentOffset.y <= 0 {
//           timelineCVC.contentOffset.y = 0
//        }
//    }
}

//保存日历事件
extension FBTimelineViewController {
    
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













