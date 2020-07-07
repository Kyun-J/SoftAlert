//
//  TopAlert.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/06/29.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

public class TopAlert {
    
    private static var isShowing = false
    private static var sView: UIView?
    private static var sLabel: UILabel?
    
    public static var isShow: Bool {
        return isShowing
    }
        
    public static func show(text: String, _ type: SoftType = .positive, _ duration: SoftDuration = .tiny, _ onDismiss: @escaping () -> Void = {}) {
        show(text: text, backgroundColor: SoftUtil.genType(type), textColor: .white, duration: SoftUtil.genDuration(duration), onDismiss: onDismiss)
    }
    
    public static func show(text: String, backgroundColor: UIColor = UIColor(red: 109/255, green: 200/255, blue: 87/255, alpha: 1.0), textColor: UIColor = UIColor.white, duration: Double = 1.0, appearDuration: Double = 0.5, dismissDuration: Double = 0.5, onDismiss: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            if isShowing { return }
            guard let keyWindow = SoftUtil.getKeyWindow() else { return }
            isShowing = true
                    
            let size = calSize()
            let width = size[0]
            let height = size[1]
            let nView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
            let nLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            nView.backgroundColor = backgroundColor
            nView.clipsToBounds = true
            nLabel.textColor = .clear
            nLabel.text = text
            nLabel.textAlignment = .center
            nLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            nLabel.sizeToFit()
            nLabel.center.x = nView.center.x
            nLabel.frame.origin.y = height - nLabel.frame.height - 1
            nView.addSubview(nLabel)
            sView = nView
            sLabel = nLabel
            
            NotificationCenter.default.addObserver(self, selector: #selector(TopAlert.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            keyWindow.addSubview(nView)
            UIView.animate(withDuration: appearDuration, animations: {
                nView.frame.size.height = height
                nLabel.textColor = textColor
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: dismissDuration, animations: {
                        nView.frame.size.height = 0.0
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
        if UIDevice.current.orientation.isLandscape {
            return [width, 20]
        } else {
            var height: CGFloat!
            if SoftUtil.hasNotch() {
                height = UIApplication.shared.statusBarFrame.height * 1.3
            } else {
                height = UIApplication.shared.statusBarFrame.height * 1.8
            }
            if height <= 0 {
                height = 20
            }
            return [width, height]
        }
    }
    
    @objc private static func rotated() {
        if !isShowing { return }
        guard let rView = sView, let rLable = sLabel else { return }
        let size = calSize()
        let width = size[0]
        let height = size[1]
        rView.frame.size.width = width
        rView.frame.size.height = height
        rLable.sizeToFit()
        rLable.center.x = rView.center.x
        rLable.frame.origin.y = height - rLable.frame.height - 1
    }

}
