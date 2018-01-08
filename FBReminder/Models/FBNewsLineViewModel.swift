//
//  FBNewsLineModel.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/12/26.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//

import UIKit

import SwiftyJSON
import MJExtension


private let news = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset=0"
private let ssss = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset=20"
private let aaaa = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset=40"

class FBNewsLineViewModel {
    lazy var newslineModels = [FBNewsLineModel]()
    
    func loadNewsLineData(finishedCallback: @escaping() -> ()) {
        var requestUrl : String = String()
        requestUrl = news
        
        NetworkTool.requestData(URLString: requestUrl, type: .get) { (result: Any) in
            let result = JSON(result)["result"]
            let news = result["data"]["feed"]["data"]
            
            for i in 0...news.count - 1 {
                let shortTitle = news[i]["short_title"]
                let detailUrl = news[i]["url"]
                let imageUrl = news[i]["image"]
                
                let itemDic : FBNewsLineModel = FBNewsLineModel()
                itemDic.detailUrl = String(describing: detailUrl)
                itemDic.imageUrl = String(describing: imageUrl)
                itemDic.shortTitle = String(describing: shortTitle)
            
                
                self.newslineModels.append(itemDic)
                finishedCallback()
            }
        }
    }
}
