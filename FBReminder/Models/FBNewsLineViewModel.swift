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


private let news = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset="
private let ssss = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset=20"
private let aaaa = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset=40"
private let bbbb = "http://saga.sports.sina.com.cn/api/news/premier_league?uid=&did=ae4dac526a62e35c86c2fcb22691d898&num=20&offset=220"

class FBNewsLineViewModel {
    lazy var newslineModels = [FBNewsLineModel]()
    
    func loadNewsLineData(itemIndex : NSInteger, finishedCallback: @escaping() -> ()) {
        var requestUrl : String = String()
        let subString = String.localizedStringWithFormat("%d", itemIndex)
        requestUrl = news + subString
        print("requestURL: ",requestUrl)
        NetworkTool.requestData(URLString: requestUrl, type: .get) { (result: Any) in
            let result = JSON(result)["result"]
            let news = result["data"]["feed"]["data"]
            print(news[5])
            if news.count > 1 {
                for i in 0...news.count - 1 {
                    
                    if news[i]["open_type"] == "text" {
                        let shortTitle = news[i]["short_title"]//标题
                        let detailUrl = news[i]["url"]//详情页
                        let imageUrl = news[i]["image"]//封面
                        
                        let itemDic : FBNewsLineModel = FBNewsLineModel()
                        itemDic.detailUrl = String(describing: detailUrl)
                        itemDic.imageUrl = String(describing: imageUrl)
                        itemDic.shortTitle = String(describing: shortTitle)
                        
                        self.newslineModels.append(itemDic)
                    }
                    
                    finishedCallback()
                }
            }else {
                //disable refresh
            }
            
        }
    }
}
