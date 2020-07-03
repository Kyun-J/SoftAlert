//
//  SoftWebPopup.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/03.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit
import WebKit

public class SoftWebPopup {
    
    private static var sWebView: WKWebView?
    private static var sWindowView: UIView?
    private static var isShowing = false
    
    private var pWebView: WKWebView?
    private var pWindowView: UIView?
    private let viewController: UIViewController!
    
    public var popupWebView: WKWebView? {
        return pWebView
    }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension SoftWebPopup {
    
    public static func globalPopup(string: String) {
        guard let url = URL(string: string) else { return }
        globalPopup(url: url)
    }
    
    public static func globalPopup(url: URL) {
        DispatchQueue.main.async {
            if isShowing { return }
            guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
            sWindowView = UIView(frame: keyWindow.bounds)
            sWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            guard let nWindowView = sWindowView else { return }
            guard let nWebView = sWebView else { return }
            isShowing = true

            let x: CGFloat = 1.0

            nWindowView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            keyWindow.addSubview(nWindowView)

            let sizeX = nWindowView.frame.width * x * 0.85
            let sizeY = nWindowView.frame.height * x * 0.78
            let startX = nWindowView.frame.width / 2 - sizeX / 2
            let startY = nWindowView.frame.height

            nWebView.frame.origin.x = startX
            nWebView.frame.origin.y = startY
            nWebView.frame.size.width = sizeX
            nWebView.frame.size.height = sizeY

            nWebView.clipsToBounds = true
            nWebView.layer.cornerRadius = 20
            nWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            nWebView.load(URLRequest(url: url))

            let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0 , width: 35, height: 35))
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2.0, y : keyWindow.frame.height / 2 + nWebView.frame.size.height / 2 + 35)
            cancelBtn.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.3)
            cancelBtn.layer.cornerRadius = 0.5 * cancelBtn.bounds.size.width
            cancelBtn.setTitle("X", for: .normal)
            cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cancelBtn.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
            cancelBtn.addTarget(self, action: #selector(webViewClose(sender:)), for: .touchUpInside)
            nWindowView.addSubview(cancelBtn)
            nWindowView.bringSubviewToFront(cancelBtn)
            nWindowView.addSubview(nWebView)
            
            NotificationCenter.default.addObserver(self, selector: #selector(SoftWebPopup.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

            UIView.animate(withDuration: 0.3) {
                nWebView.frame.origin.y = keyWindow.frame.height / 2 - nWebView.frame.height / 2
            }
        }
    }
        
    @objc static func webViewClose(sender : UIButton?) {
        if !isShowing { return }
        guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
        UIView.animate(withDuration: 0.3, animations: {
            sWebView?.frame.origin.y = keyWindow.frame.height
        }, completion: { _ in
            sWindowView?.removeFromSuperview()
            sWebView?.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
            sWebView = nil
            sWindowView = nil
            isShowing = false
        })
    }
    
    @objc private static func rotated() {
        
    }
    
}

extension SoftWebPopup {
    
    
    
}
