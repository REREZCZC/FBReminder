//
//  NetworkTool.swift
//  News
//
//  Created by 瑞宁科技02 on 2017/8/4.
//  Copyright © 2017年 reining. All rights reserved.
//

import UIKit
import Alamofire

enum MethordType{
    case get
    case post
}
class NetworkTool {

    class func  requestData(URLString: String,type:MethordType , paraters: [String : Any]? = nil , finishedCallBack: @escaping (_ result: Any) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: paraters).responseJSON { (response) in
            // 校验是否有结果
            
            guard let result = response.result.value else{
                print("********ERROR*******")
                print(response.result.error ?? "")
                return
            }
            
            // 2.将结果回调出去
            finishedCallBack(result)
        }
    }
    
}
