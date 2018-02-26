//
//  FBNewsDetailViewController.swift
//  FBReminder
//
//  Created by ren zhicheng on 2018/2/26.
//  Copyright © 2018年 renzhicheng. All rights reserved.
//

import UIKit
import WebKit


class FBNewsDetailViewController: UIViewController {
    var detailUrl : String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView : WKWebView = {
            let web = WKWebView( frame: CGRect(x:0, y:64,width:self.view.frame.size.width, height:self.view.frame.size.height))
            /// 设置访问的URL
            let url = NSURL(string: detailUrl)
            /// 根据URL创建请求
            let requst = NSURLRequest(url: url! as URL)
            /// 设置代理
            //        web.uiDelegate = self
            web.navigationDelegate = self as? WKNavigationDelegate
            /// WKWebView加载请求
            web.load(requst as URLRequest)
            
            return web
        }()
        
        self.view.addSubview(webView)
    }



}
















