//
//  FBTimelineCollectionViewCell.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/10/11.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//

import UIKit
import SnapKit

class FBTimelineCollectionViewCell: UICollectionViewCell {
    //home
    fileprivate lazy var homeTeamIcon : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate lazy var homeTeamTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //visit
    fileprivate lazy var visitTeamIcon : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate lazy var visitTeamTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //gameInfo
    lazy var timeInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    lazy var dateInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellModel : FBTimelineModel? {
        didSet {
            dateInfo.text = cellModel?.date
            timeInfo.text = cellModel?.time
            homeTeamTitle.text = cellModel?.team1
            visitTeamTitle.text = cellModel?.team2
        }
    }
    
}
extension FBTimelineCollectionViewCell {
    fileprivate func setupUI(){
        //homeTeamIcon
        homeTeamIcon.backgroundColor = UIColor.green
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
            make.width.equalTo(80)
            make.height.equalTo(18)
            make.centerX.equalTo(homeTeamIcon.snp.centerX)
            make.top.equalTo(homeTeamIcon.snp.bottom).offset(8)
        }
        
        //visitTeamIcon
        visitTeamIcon.backgroundColor = UIColor.green
        self.addSubview(visitTeamIcon)
        visitTeamIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.right.equalTo(-30)
            make.centerY.equalTo(homeTeamIcon.snp.centerY)
        }
        //visitTeamTitle
        visitTeamTitle.font = UIFont.systemFont(ofSize: 13)
        visitTeamTitle.textAlignment = .center
        self.addSubview(visitTeamTitle)
        visitTeamTitle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(80)
            make.height.equalTo(18)
            make.centerX.equalTo(visitTeamIcon.snp.centerX)
            make.centerY.equalTo(homeTeamTitle.snp.centerY)
        }
        
        dateInfo.textAlignment = .center
        dateInfo.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(dateInfo)
        dateInfo.snp.makeConstraints { (make)-> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(homeTeamIcon.snp.top).offset(4)
        }
        
        //timeInfo
        timeInfo.textAlignment = .center
        timeInfo.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(timeInfo)
        timeInfo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(dateInfo.snp.centerX)
            make.bottom.equalTo(homeTeamIcon.snp.bottom).offset(-2)
        }
        
        
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 8
        
        
    }
}


extension FBTimelineCollectionViewCell {
    
}









