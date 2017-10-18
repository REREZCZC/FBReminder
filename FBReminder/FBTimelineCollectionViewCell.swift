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
    lazy var gameInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var timeInfo : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellModel : FBTimelineModel? {
        didSet {
            gameInfo.text = cellModel?.title
            timeInfo.text = cellModel?.time
            homeTeamTitle.text = cellModel?.date
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
        homeTeamTitle.backgroundColor = UIColor.brown
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
        visitTeamTitle.backgroundColor = UIColor.brown
        self.addSubview(visitTeamTitle)
        visitTeamTitle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(80)
            make.height.equalTo(18)
            make.centerX.equalTo(visitTeamIcon.snp.centerX)
            make.centerY.equalTo(homeTeamTitle.snp.centerY)
        }
        
        //gameInfo
        gameInfo.backgroundColor = UIColor.gray
        self.addSubview(gameInfo)
        gameInfo.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(homeTeamIcon.snp.right).offset(10)
            make.right.equalTo(visitTeamIcon.snp.left).offset(-10)
            make.height.equalTo(18)
            make.top.equalTo(homeTeamIcon.snp.top).offset(3)
        }
        //timeInfo
        timeInfo.backgroundColor = UIColor.gray
        self.addSubview(timeInfo)
        timeInfo.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(gameInfo.snp.width)
            make.height.equalTo(gameInfo.snp.height)
            make.centerX.equalTo(gameInfo.snp.centerX)
            make.bottom.equalTo(homeTeamIcon.snp.bottom).offset(-3)
        }
        
        
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 8
        
        
    }
}


extension FBTimelineCollectionViewCell {
    
}









