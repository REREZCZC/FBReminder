//
//  CardViewController.swift
//  CardsUI
//
//  Created by Eugène Peschard on 24/04/2017.
//

import UIKit
import WebKit

class CardViewController: UIViewController,UIScrollViewDelegate {
    var detailUrl : String = "";
    
    var darkStatusBar = true
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height)
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
  
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
        self.commonInit()
    }
  
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    fileprivate lazy var topButton : UIImageView = UIImageView(image:#imageLiteral(resourceName: "down") )
  

    
    lazy var webView : WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:30,width:self.view.frame.size.width, height:self.view.frame.size.height))
        let url = NSURL(string: detailUrl)
        let requst = NSURLRequest(url: url! as URL)
        web.navigationDelegate = self as? WKNavigationDelegate
        web.load(requst as URLRequest)
        return web
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(_:)))
//        view.addGestureRecognizer(panGesture)
        
        let dismissGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissTap))
        view.addGestureRecognizer(dismissGesture)
        
        topButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)
        topButton.backgroundColor = UIColor.white
        topButton.contentMode = .center
        self.view.addSubview(topButton)
        
        
        self.view.addSubview(webView)
        webView.scrollView.bounces = false
        webView.scrollView.delegate = self
        roundViews()
  }
    
    @objc func dismissTap() {
        self.dismiss(animated: true) {
            print("dismidd")
        }
    }
  
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if webView.scrollView.contentOffset.y < -50 {
            self.dismiss(animated: true) {
                print("dismiss success")
            }
        }
        
    }
    
//    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
//
//        let translation = recognizer.translation(in: self.view)
//        let velocity = recognizer.velocity(in: self.view)
//        let y = self.view.frame.minY
//        print("miny: \(y)")
//        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
//            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: self.view)
//        }
//
//        if recognizer.state == .ended {
//            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
//            duration = duration > 1.3 ? 1 : duration
//            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
//            if  velocity.y >= 0 {
//                self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
//            } else {
//                self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
//            }
//
//           }, completion: nil)
//        }
//    }
  
    func roundViews() {
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        toggleStatusBar()
    }
}

// MARK: - UIViewControllerTransitioningDelegate methods

extension CardViewController: UIViewControllerTransitioningDelegate {
  
  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
    
    if presented == self {
      return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    return nil
  }
  
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if presented == self {
      return CardAnimationController(isPresenting: true)
    } else {
      return nil
    }
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if dismissed == self {
      return CardAnimationController(isPresenting: false)
    } else {
      return nil
    }
  }
  
  func toggleStatusBar() {
    if darkStatusBar {
      UIApplication.shared.statusBarStyle = .lightContent
    } else {
      UIApplication.shared.statusBarStyle = .default
    }
  }
}
