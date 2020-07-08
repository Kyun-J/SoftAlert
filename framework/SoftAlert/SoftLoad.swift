//
//  SoftLoad.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/07/07.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

public class SoftLoad {
    
    private static var isShowing = false
    private static let viewForActivityIndicator = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 90, height: 90))
    private static let activityIndicatorView = UIActivityIndicatorView()
    private static let loadingTextLabel = UILabel()
    private static let background = UIView()
    
    public static var defaultText = "Loading"
    public static var isShow: Bool {
        return isShowing
    }
    
    @available(iOS 12.0, *)
    public static func show(userStyle: UIUserInterfaceStyle? = nil) {
        show(text: defaultText, userStyle)
    }
    
    @available(iOS 12.0, *)
    public static func show(text: String = defaultText, _ userStyle: UIUserInterfaceStyle? = nil) {
        DispatchQueue.main.async {
            if !work(text: text) { return }
            var style = userStyle
            if style == nil { style = SoftUtil.getKeyWindow()?.rootViewController?.traitCollection.userInterfaceStyle }
            if style == .dark {
                loadingTextLabel.textColor = UIColor.black
                activityIndicatorView.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                viewForActivityIndicator.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
            } else {
                loadingTextLabel.textColor = UIColor.white
                activityIndicatorView.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                viewForActivityIndicator.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
            }
        }
    }
    
    
    public static func showStyle(text: String = defaultText, textColor: UIColor = UIColor.white, indicatorColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)) {
        DispatchQueue.main.async {
            if !work(text: text) { return }
            loadingTextLabel.textColor = textColor
            activityIndicatorView.color = indicatorColor
            viewForActivityIndicator.backgroundColor =  backgroundColor
        }
    }
    
    private static func work(text: String) -> Bool {
        if isShowing { return false }
        guard let keyWindow = SoftUtil.getKeyWindow() else { return false }
        isShowing = true
        
        background.frame = keyWindow.frame
        viewForActivityIndicator.center = CGPoint(x: keyWindow.frame.size.width / 2.0, y: (keyWindow.frame.size.height) / 2.0)
        viewForActivityIndicator.layer.cornerRadius = 10
        background.addSubview(viewForActivityIndicator)
    
        activityIndicatorView.center = CGPoint(x: viewForActivityIndicator.frame.size.width / 2.0, y: (viewForActivityIndicator.frame.size.height) / 2.0)
    
        loadingTextLabel.text = text
        loadingTextLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: viewForActivityIndicator.frame.size.height * 0.85)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .whiteLarge
        viewForActivityIndicator.addSubview(activityIndicatorView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        activityIndicatorView.startAnimating()
        keyWindow.addSubview(background)
        return true
    }

    public static func stop() {
        DispatchQueue.main.async {
            if !isShowing { return }
            background.removeFromSuperview()
            viewForActivityIndicator.removeFromSuperview()
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
            isShowing = false
        }
    }
    
    @objc private static func rotated() {
        if !isShowing { return }
        guard let keyWindow = SoftUtil.getKeyWindow() else { return }
        background.frame = keyWindow.frame
        viewForActivityIndicator.center = CGPoint(x: keyWindow.frame.size.width / 2.0, y: (keyWindow.frame.size.height) / 2.0)
        activityIndicatorView.center = CGPoint(x: viewForActivityIndicator.frame.size.width / 2.0, y: (viewForActivityIndicator.frame.size.height) / 2.0)
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: viewForActivityIndicator.frame.size.height * 0.85)
    }
    
}
