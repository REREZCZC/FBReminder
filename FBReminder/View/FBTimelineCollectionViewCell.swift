//
//  FBTimelineCollectionViewCell.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/10/11.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class FBTimelineCollectionViewCell: UICollectionViewCell {
    //home
    fileprivate lazy var homeTeamIcon : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate lazy var homeTeamTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //visit
    fileprivate lazy var visitTeamIcon : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate lazy var visitTeamTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //gameInfo
    lazy var timeInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var dateInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var weekInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellModel : FBTimelineModel? {
        didSet {
            //日期
            var date : String = String()
            date = (cellModel?.date)!
            dateInfo.text = date
            
            //星期
            weekInfo.text = getDayOFWeek(date)
            //时间
            timeInfo.text = cellModel?.time
            homeTeamTitle.text = cellModel?.team1
            visitTeamTitle.text = cellModel?.team2
            
            //使用 kingfisher 设置主客队图标
            let homeTeamURL = URL(string: (cellModel!.team1IconUrl))
            homeTeamIcon.kf.setImage(with: homeTeamURL)
            
            let visitTeamURL = URL(string: (cellModel!.team2IconUrl))
            visitTeamIcon.kf.setImage(with: visitTeamURL)
        }
    }
    
}
extension FBTimelineCollectionViewCell {
    fileprivate func setupUI(){
        //homeTeamIcon
        self.addSubview(homeTeamIcon)
        homeTeamIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.left.equalTo(30)
            make.top.equalTo(16)
        }
        //homeTeamTitle
        homeTeamTitle.font = UIFont.systemFont(ofSize: 13)
        homeTeamTitle.textAlignment = .center
        self.addSubview(homeTeamTitle)
        homeTeamTitle.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(homeTeamIcon.snp.centerX)
            make.bottom.equalTo(-10)
        }
        
        //visitTeamIcon
        self.addSubview(visitTeamIcon)
        visitTeamIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.right.equalTo(-30)
            make.centerY.equalTo(homeTeamIcon.snp.centerY)
        }
        //visitTeamTitle
        visitTeamTitle.font = UIFont.systemFont(ofSize: 14)
        visitTeamTitle.textAlignment = .center
        self.addSubview(visitTeamTitle)
        visitTeamTitle.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(visitTeamIcon.snp.centerX)
            make.centerY.equalTo(homeTeamTitle.snp.centerY)
        }
        
        //timeInfo
        timeInfo.textAlignment = .center
        timeInfo.textColor = UIColor.white
        timeInfo.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(timeInfo)
        timeInfo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        dateInfo.textAlignment = .center
        dateInfo.font = UIFont.systemFont(ofSize: 14)
        dateInfo.textColor = UIColor.white
        self.addSubview(dateInfo)
        dateInfo.snp.makeConstraints { (make)-> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(timeInfo.snp.top).offset(-2)
        }
        
        weekInfo.textAlignment = .center
        weekInfo.font = UIFont.systemFont(ofSize: 14)
        weekInfo.textColor = UIColor.white
        self.addSubview(weekInfo)
        weekInfo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(timeInfo.snp.bottom).offset(2)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 8
        
        
        
    }
}


extension FBTimelineCollectionViewCell {

    fileprivate func getDayOFWeek(_ date : String) -> String {
        
        var processData = date
        if processData.characters.count < 9 {
            processData = "2017-10-21"
        }
        
        let yearEnd = processData.index(processData.endIndex, offsetBy: -6)
        let year = processData[..<yearEnd]
        
        
        let monthStart = processData.index(processData.startIndex, offsetBy: 5)
        let monthEnd = processData.index(date.endIndex, offsetBy: -3)
        let monthRange = Range<String.Index>(uncheckedBounds: (lower: monthStart, upper: monthEnd))
        let month = processData[monthRange]
        
        let dayStart = processData.index(processData.startIndex, offsetBy: 8)
        let day = processData[dayStart...]
        
        var y = Int(year)!
        let m = Int(month)!
        let d = Int(day)!
        
        if (m < 3) {
            y -= 1
        }
        let c = y / 100
        let g = y % 100
        
        let monthTable = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
        let e = monthTable[m - 1]
        
        let centuryTable = [0, 5, 3, 1]
        let f = centuryTable[c % 4]
        
        let h = (d + e + f + g + g/4) % 7
//        return (h + 6) % 7 + 1
        
        let weekNumber = (h + 6) % 7 + 1
        switch weekNumber {
        case 1 :
            return "星期一"
        case 2 :
            return "星期二"
        case 3 :
            return "星期三"
        case 4 :
            return "星期四"
        case 5 :
            return "星期五"
        case 6 :
            return "星期六"
        case 7 :
            return "星期日"
        default :
            return "其他"
        }
        
    }
//    public func dayOfWeek3(_ y: Int, _ m: Int, _ d: Int) -> Int {
//        var y = y
//        if (m < 3) {
//            y -= 1
//        }
//        let c = y / 100
//        let g = y % 100
//
//        let monthTable = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
//        let e = monthTable[m - 1]
//
//        let centuryTable = [0, 5, 3, 1]
//        let f = centuryTable[c % 4]
//
//        let h = (d + e + f + g + g/4) % 7
//        return (h + 6) % 7 + 1
//    }
    

}









