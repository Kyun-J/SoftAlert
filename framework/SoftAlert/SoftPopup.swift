//
//  SoftWebPopup.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/03.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

open class SoftPopup {
    
    private static var sView: UIView?
    private static var sWindowView: UIView?
    private static var isShowing = false
    private static var ratio: CGFloat = 1.0
    
    public static var isShow: Bool {
        return isShowing
    }
    
    public static var popupView: UIView? {
        get {
            return sView
        }
        set(newVal) {
            if !isShowing {
                sView = newVal
            }
        }
    }
    
    public static func popup(view: UIView, ratio: CGFloat = 1.0) {
        DispatchQueue.main.async {
            if isShowing { return }
            guard let keyWindow = SoftUtil.getKeyWindow() else { return }
            sWindowView = UIView(frame: keyWindow.bounds)
            sView = view
            guard let nWindowView = sWindowView, let nView = sView else { return }
            isShowing = true
            self.ratio = ratio

            nWindowView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            keyWindow.addSubview(nWindowView)

            nView.frame.size.width = nWindowView.frame.width * ratio * 0.85
            nView.frame.size.height = nWindowView.frame.height * ratio * 0.81
            nView.frame.origin.x = nWindowView.frame.width / 2 - nView.frame.width / 2
            nView.frame.origin.y = nWindowView.frame.height
            nWindowView.addSubview(nView)

            nView.clipsToBounds = true
            nView.layer.cornerRadius = 20
            nView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                    
            let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0 , width: 35, height: 35))
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2.0, y : nWindowView.frame.height + nView.frame.height)
            cancelBtn.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.3)
            cancelBtn.layer.cornerRadius = 0.5 * cancelBtn.bounds.size.width
            cancelBtn.setTitle("X", for: .normal)
            cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cancelBtn.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
            cancelBtn.addTarget(self, action: #selector(webViewClose(sender:)), for: .touchUpInside)
            nWindowView.addSubview(cancelBtn)
            nWindowView.bringSubviewToFront(cancelBtn)
                                    
            NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

            UIView.animate(withDuration: 0.3, animations: {
                posView(nWindowView)
            })
        }
    }
        
    @objc private static func webViewClose(sender : UIButton?) {
        if !isShowing { return }
        guard let keyWindow = SoftUtil.getKeyWindow() else { return }
        sWindowView?.subviews[1].removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            sWindowView?.subviews[0].frame.origin.y = keyWindow.frame.height
        }, completion: { _ in
            sWindowView?.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
            sWindowView = nil
            isShowing = false
        })
    }
    
    @objc private static func rotated() {
        if !isShowing { return }
        guard let keyWindow = SoftUtil.getKeyWindow() else { return }
        guard let nWindowView = sWindowView else { return }
        nWindowView.frame = keyWindow.frame
        posView(nWindowView)
    }
    
    private static func posView(_ nWindowView: UIView) {
        let nView = nWindowView.subviews[0]
        let cancelBtn = nWindowView.subviews[1]
        nView.frame.size.width = nWindowView.frame.width * ratio * 0.85
        nView.frame.size.height = nWindowView.frame.height * ratio * 0.81
        nView.frame.origin.x = nWindowView.frame.width / 2 - nView.frame.width / 2
        if UIDevice.current.orientation.isLandscape || UIApplication.shared.statusBarFrame.height <= 0 {
            nView.frame.origin.y = nWindowView.frame.height / 2.25 - nView.frame.height / 2
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2, y : nWindowView.frame.height / 2.25 + nView.frame.height / 2 + 24)
        } else {
            nView.frame.origin.y = nWindowView.frame.height / 2 - nView.frame.height / 2
            cancelBtn.center = CGPoint(x: nWindowView.frame.size.width / 2, y : nWindowView.frame.height / 2 + nView.frame.height / 2 + 27)
        }
    }
}
