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

private let kTimelineCellID = "kTimelineCellID"
private let kBoundsWidth = "self.view.bounds.width"
private let kBoundsHeight = "self.view.bounds.height"


fileprivate var timeLineItemArray : NSMutableArray = NSMutableArray()

class FBTimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    fileprivate lazy var timelineVM : FBTimelineViewModel = FBTimelineViewModel()
    fileprivate lazy var timelineCVC : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.view.bounds.width - 20, height: 100)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        
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
            
//            self.timelineVM.loadTimelineData {
//                self.timelineCVC.endFooterRefreshing()
//                self.timelineCVC.reloadData()
//            }
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

}

//获得数据
extension FBTimelineViewController {
    fileprivate func loadData() {
//        timelineVM.loadTimelineData {
//            self.timelineCVC.reloadData()
//        }
        timelineVM.loadTimelineData(preDate: "") {
            self.timelineCVC.reloadData()
        }
    }
}
















