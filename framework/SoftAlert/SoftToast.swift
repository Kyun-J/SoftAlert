//
//  SoftToast.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/02.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

public class SoftToast {
    
    public static func show(text: String, _ duration: SoftAlertDuration = .tiny, _ onDismiss: () -> Void = {}) {
        show(text: text, duration: SoftAlertUtil.genDuration(duration), onDismiss: onDismiss)
    }
    
    public static func show(text: String, duration: Double, onDismiss: () -> Void = {}) {
        DispatchQueue.main.async {
            guard let keyWindow = SoftAlertUtil.getKeyWindow() else { return }
            let nView = UIView()
            let nLable = UILabel()
            
            nView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width * 0.6  , height: 50)
            nView.center = CGPoint(x: keyWindow.bounds.width / 2, y: keyWindow.bounds.height - 100)
            nView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            nView.clipsToBounds = true
            nView.layer.cornerRadius = 25
            nView.alpha = 0
            
            nLable.frame = CGRect(x: 0, y: 0, width: nView.frame.width, height: 50)
            nLable.numberOfLines = 0
            nLable.textColor = UIColor.white
            nLable.center = nView.center
            nLable.text = text
            nLable.textAlignment = .center
            nLable.center = CGPoint(x: nView.bounds.width / 2, y: nView.bounds.height / 2)
            nView.addSubview(nLable)
            
            keyWindow.addSubview(nView)
                    
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
                    }
                }
            }
        }
    }
    
}
