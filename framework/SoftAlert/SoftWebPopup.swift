//
//  SoftWebPopup.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/03.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit
import WebKit

open class SoftWebPopup {
    
    public static var popupWebView: WKWebView? {
        get {
            return self.sWebView
        }
        set(newVal) {
            if !isShowing {
                self.sWebView = newVal
            }
        }
    }
    private static var sWebView: WKWebView?
    private static var sWindowView: UIView?
    private static var isShowing = false
    private static var ratio: CGFloat = 1.0
        
    public static func popup(string: String, ratio: CGFloat = 1.0) {
        guard let url = URL(string: string) else { return }
        self.ratio = ratio
        popup(url: url, ratio: ratio)
    }
    
    public static func popup(url: URL, ratio: CGFloat = 1.0) {
        self.ratio = ratio
        popup()
        DispatchQueue.main.async {
            sWebView?.load(URLRequest(url: url))
        }
    }
    
    private static func popup() {
        DispatchQueue.main.async {
            if isShowing { return }
            guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
            sWindowView = UIView(frame: keyWindow.bounds)
            if sWebView == nil { sWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) }
            guard let nWindowView = sWindowView, let nWebView = sWebView else { return }
            isShowing = true

            nWindowView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            keyWindow.addSubview(nWindowView)

            nWebView.frame.size.width = nWindowView.frame.width * ratio * 0.85
            nWebView.frame.size.height = nWindowView.frame.height * ratio * 0.81
            nWebView.frame.origin.x = nWindowView.frame.width / 2 - nWebView.frame.width / 2
            nWebView.frame.origin.y = nWindowView.frame.height
            
            nWindowView.addSubview(nWebView)

            nWebView.clipsToBounds = true
            nWebView.layer.cornerRadius = 20
            nWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0 , width: 35, height: 35))
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2.0, y : nWindowView.frame.height + nWebView.frame.height)
            cancelBtn.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.3)
            cancelBtn.layer.cornerRadius = 0.5 * cancelBtn.bounds.size.width
            cancelBtn.setTitle("X", for: .normal)
            cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cancelBtn.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
            cancelBtn.addTarget(self, action: #selector(webViewClose(sender:)), for: .touchUpInside)
            nWindowView.addSubview(cancelBtn)
            nWindowView.bringSubviewToFront(cancelBtn)
                                    
            NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

            UIView.animate(withDuration: 0.3) {
                posWebView(nWindowView)
            }
        }
    }
        
    @objc private static func webViewClose(sender : UIButton?) {
        if !isShowing { return }
        guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
        sWindowView?.subviews[1].removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            sWindowView?.subviews[0].frame.origin.y = keyWindow.frame.height
        }, completion: { _ in
            sWebView?.load(URLRequest(url: URL(string:"about:blank")!))
            sWindowView?.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
            sWindowView = nil
            isShowing = false
        })
    }
    
    @objc private static func rotated() {
        if !isShowing { return }
        guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
        guard let nWindowView = sWindowView else { return }
        nWindowView.frame = keyWindow.frame
        posWebView(nWindowView)
    }
    
    private static func posWebView(_ nWindowView: UIView) {
        let nWebView = nWindowView.subviews[0]
        let cancelBtn = nWindowView.subviews[1]
        nWebView.frame.size.width = nWindowView.frame.width * ratio * 0.85
        nWebView.frame.size.height = nWindowView.frame.height * ratio * 0.81
        nWebView.frame.origin.x = nWindowView.frame.width / 2 - nWebView.frame.width / 2
        if UIDevice.current.orientation.isLandscape || UIApplication.shared.statusBarFrame.height <= 0 {
            nWebView.frame.origin.y = nWindowView.frame.height / 2.25 - nWebView.frame.height / 2
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2, y : nWindowView.frame.height / 2.25 + nWebView.frame.height / 2 + 27)
        } else {
            nWebView.frame.origin.y = nWindowView.frame.height / 2 - nWebView.frame.height / 2
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2, y : nWindowView.frame.height / 2 + nWebView.frame.height / 2 + 27)
        }
        
    }
    
}
