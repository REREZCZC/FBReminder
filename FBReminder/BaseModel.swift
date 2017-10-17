//
//  BaseModel.swift
//  FBReminder
//
//  Created by ren zhicheng on 2017/10/17.
//  Copyright © 2017年 renzhicheng. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {

    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
    }
}
