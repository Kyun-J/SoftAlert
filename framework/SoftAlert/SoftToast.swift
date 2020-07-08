//
//  SoftToast.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/02.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

open class SoftToast {
    
    private static var showViews: [UIView] = []
    
    public static func show(text: String, _ duration: SoftDuration = .tiny, _ onDismiss: @escaping () -> Void = {}) {
        show(text: text, duration: SoftUtil.genDuration(duration), onDismiss: onDismiss)
    }
    
    public static func show(text: String, duration: Double, backgroundColor: UIColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), textColor: UIColor = UIColor.white, onDismiss: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            guard let keyWindow = SoftUtil.getKeyWindow() else { return }
            let nView = UIView()
            let nLable = UILabel()
            
            nView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width * 0.6  , height: 50)
            nView.center = CGPoint(x: keyWindow.bounds.width / 2, y: keyWindow.bounds.height - 100)
            nView.backgroundColor = backgroundColor
            nView.clipsToBounds = true
            nView.layer.cornerRadius = 25
            nView.alpha = 0
            
            nLable.frame = CGRect(x: 0, y: 0, width: nView.frame.width, height: 50)
            nLable.numberOfLines = 0
            nLable.textColor = textColor
            nLable.text = text
            nLable.textAlignment = .center
            nLable.center = CGPoint(x: nView.bounds.width / 2, y: nView.bounds.height / 2)
            nView.addSubview(nLable)
            
            NotificationCenter.default.addObserver(self, selector: #selector(SoftToast.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            keyWindow.addSubview(nView)
            
            showViews.append(nView)
                                            
            UIView.animate(withDuration: 0.5, animations: {
                nView.alpha = 0.9
            })
            { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration ){
                    UIView.animate(withDuration: 0.5, animations: {
                        nView.alpha = 0
                    }) { _ in
                        nLable.removeFromSuperview()
                        nView.removeFromSuperview()
                        showViews.remove(at: showViews.firstIndex(of: nView)!)
                        if showViews.count == 0 { NotificationCenter.default.removeObserver(self) }
                        onDismiss()
                    }
                }
            }
        }
    }
    
    @objc private static func rotated() {
        guard let keyWindow = SoftUtil.getKeyWindow() else { return }
        showViews.forEach { (nView) in
            let nLable = nView.subviews[0]
            nView.frame.size.width = keyWindow.frame.width * 0.6
            nView.frame.size.height = 50
            nView.center = CGPoint(x: keyWindow.bounds.width / 2, y: keyWindow.bounds.height - 100)
            nLable.frame.size.width = nView.frame.width
            nLable.frame.size.height = 50
            nLable.center = CGPoint(x: nView.bounds.width / 2, y: nView.bounds.height / 2)
        }
        
    }
    
}
