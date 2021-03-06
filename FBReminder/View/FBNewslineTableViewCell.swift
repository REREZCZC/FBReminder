//
//  FBNewslineTableViewCell.swift
//  FBReminder
//
//  Created by zhicheng ren on 2018/1/8.
//  Copyright © 2018年 renzhicheng. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class FBNewslineTableViewCell: UITableViewCell {
    fileprivate let teamFilter : String = "阿森纳"
    fileprivate lazy var shortTitle : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fileprivate lazy var separatorLine : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellModel : FBNewsLineModel? {
        didSet {
            shortTitle.text = cellModel?.shortTitle
            if (shortTitle.text?.contains(teamFilter))! {
                shortTitle.textColor = UIColor.red
            }else {
                shortTitle.textColor = UIColor.orange
            }
        }
    }
    
    fileprivate func setupUI() {
        separatorLine.backgroundColor = UIColor.red
        self.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(0.4)
        }
        
        shortTitle.textAlignment = .left
        shortTitle.textColor = UIColor.orange
        shortTitle.font = UIFont.init(name: "DolbyGustan-Book", size: 18)
        
        self.addSubview(shortTitle)
        shortTitle.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-10)
            make.top.equalTo(self.snp.top).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
    }
}
