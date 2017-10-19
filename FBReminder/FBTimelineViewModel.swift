//
//  FBTimelineViewModel.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/10/17.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//


import UIKit
import SwiftyJSON
import MJExtension

//first request
private let englandTimelineURL       = "http://platform.sina.com.cn/sports_all/client_api?_sport_t_=livecast&l_type=4&_sport_a_=typeMatches&__os__=iphone&app_key=2923419926&__version__=3.13.1.1%20HTTP/1.1"
private let chinaTimelineURL         = "http://platform.sina.com.cn/sports_all/client_api?_sport_t_=livecast&l_type=213&_sport_a_=typeMatches&__os__=iphone&app_key=2923419926&__version__=3.13.1.1%20HTTP/1.1"


//update
private let englandUpdateTimelineURL = "http://platform.sina.com.cn/sports_all/client_api?l_type=4&_sport_a_=typeMatches&begin=2017-10-31&direct=topre&__os__=iphone&app_key=2923419926&__version__=3.13.1.1&_sport_t_=livecast"
private let chinaUpdateTimelineURL   = "http://platform.sina.com.cn/sports_all/client_api?l_type=213&_sport_a_=typeMatches&begin=2017-11-05&direct=topre&__os__=iphone&app_key=2923419926&__version__=3.13.1.1&_sport_t_=livecast"


class FBTimelineViewModel {
    lazy var timelineModels = [FBTimelineModel]()
}

extension FBTimelineViewModel {
    func loadTimelineData(finishedCallback : @escaping () -> ()) {
        NetworkTool.requestData(URLString: englandTimelineURL, type: .get) { (result: Any) in
            let result = JSON(result)["result"]
            let previewGameInfo = result["data"]["pre"]
            
            //上啦刷新启示日期参数
            let refreshUrlParameter = result["pre_date_begin"]

            for i in 0...previewGameInfo.count {
                //主队名
                let team1 = previewGameInfo[i]["Team1"]
                //客队名
                let team2 = previewGameInfo[i]["Team2"]
                //比赛日期
                let date = previewGameInfo[i]["date"]
                //比赛时间
                let time = previewGameInfo[i]["time"]
                //主队图标
                let team1IconUrl = previewGameInfo[i]["Flag1"]
                //客队图标
                let team2IconUrl = previewGameInfo[i]["Flag2"]
                
                
                
                let itemDic : FBTimelineModel = FBTimelineModel()
                itemDic.team1 = String(describing: team1)
                itemDic.team2 = String(describing: team2)
                itemDic.date = String(describing: date)
                itemDic.time = String(describing: time)
                
                self.timelineModels.append(itemDic)
                
                finishedCallback()
            }
        }
    }
}
















