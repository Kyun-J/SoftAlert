//
//  BottomAlert.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/02.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

public class BottomAlert {
    
    private static var isShowing = false
    private static var sView: UIView?
    private static var sLabel: UILabel?
    
    public static var isShow: Bool {
        return isShowing
    }
        
    public static func show(text: String, _ type: SoftAlertType = .positive, _ duration: SoftAlertDuration = .tiny, _ onDismiss: @escaping () -> Void = {}) {
        show(text: text, backgroundColor: SoftAlertUtil.genType(type), textColor: .white, duration: SoftAlertUtil.genDuration(duration), onDismiss: onDismiss)
    }
    
    public static func show(text: String, backgroundColor: UIColor = UIColor(red: 109/255, green: 200/255, blue: 87/255, alpha: 1.0), textColor: UIColor = UIColor.white, duration: Double = 1.0, appearDuration: Double = 0.5, dismissDuration: Double = 0.5, onDismiss: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            if isShowing { return }
            guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
            isShowing = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(BottomAlert.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            let size = calSize()
            let width = size[0]
            let height = size[1]
            let nView = UIView(frame: CGRect(x: 0, y: keyWindow.frame.height, width: width, height: height))
            let nLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            nView.backgroundColor = backgroundColor
            nView.clipsToBounds = true
            nLabel.textColor = .clear
            nLabel.text = text
            nLabel.textAlignment = .center
            nLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            nLabel.sizeToFit()
            nLabel.center.x = nView.center.x
            nLabel.frame.origin.y = height * 0.1
            nView.addSubview(nLabel)
            sView = nView
            sLabel = nLabel
            
            keyWindow.addSubview(nView)
            UIView.animate(withDuration: appearDuration, animations: {
                nView.frame.origin.y = keyWindow.frame.height - height
                nLabel.textColor = textColor
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: dismissDuration, animations: {
                        nView.frame.origin.y = keyWindow.frame.height
                    }, completion: { _ in
                        nView.removeFromSuperview()
                        nLabel.removeFromSuperview()
                        NotificationCenter.default.removeObserver(self)
                        sView = nil
                        sLabel = nil
                        isShowing = false
                        onDismiss()
                    })
                }
            })
        }
    }
    
    private static func calSize() -> [CGFloat] {
        let width = UIScreen.main.bounds.width
        let hasNotch = SoftAlertUtil.hasNotch()
        if UIDevice.current.orientation.isLandscape || UIApplication.shared.statusBarFrame.height <= 0 {
            if hasNotch {
                return [width, 40]
            } else {
                return [width, 20]
            }
        } else {
            var height: CGFloat!
            if hasNotch {
                height = UIApplication.shared.statusBarFrame.height * 1.3
            } else {
                height = UIApplication.shared.statusBarFrame.height * 1.8
            }
            return [width, height]
        }
    }
    
    @objc private static func rotated() {
        if !isShowing { return }
        guard let rView = sView, let rLable = sLabel else { return }
        guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
        let size = calSize()
        let width = size[0]
        let height = size[1]
        rView.frame.size.width = width
        rView.frame.size.height = height
        rView.frame.origin.y = keyWindow.frame.height - height
        rLable.sizeToFit()
        rLable.center.x = rView.center.x
        rLable.frame.origin.y = height - rLable.frame.height - 1
        rLable.frame.origin.y = height * 0.1
    }


}

