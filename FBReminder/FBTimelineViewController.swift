//
//  FBTimelineViewController.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/10/11.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//

import UIKit
import SwiftyJSON


private let kTimelineCellID = "kTimelineCellID"
private let kBoundsWidth = "self.view.bounds.width"
private let kBoundsHeight = "self.view.bounds.height"


fileprivate var timeLineItemArray : NSMutableArray = NSMutableArray()

class FBTimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate lazy var timelineCVC : UICollectionView = UICollectionView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.view.bounds.width - 20, height: 100)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        timelineCVC = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        self.view.addSubview(timelineCVC)
        timelineCVC.delegate = self
        timelineCVC.dataSource = self
        timelineCVC.backgroundColor = UIColor.white
        timelineCVC.register(FBTimelineCollectionViewCell.self, forCellWithReuseIdentifier: kTimelineCellID)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
}


extension FBTimelineViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 400
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FBTimelineCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kTimelineCellID, for: indexPath) as! FBTimelineCollectionViewCell
        print("\(timeLineItemArray[0])")
        
        return cell
    }

}

//获得数据
extension FBTimelineViewController {
    
}
















