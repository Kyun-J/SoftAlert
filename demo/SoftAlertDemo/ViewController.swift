//
//  ViewController.swift
//  SoftAlertDemo
//
//  Created by 황견주 on 2020/06/29.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit
import SoftAlert
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func topPosAlertTouch(_ sender: UIButton) {
        TopAlert.show(text: "Top Alert Text") {
            print("dismiss")
        }
    }

    @IBAction func bottomNegAlertTouch(_ sender: UIButton) {
        BottomAlert.show(text: "Bottom Alert Text", .negative, .long)
    }
    
    @IBAction func shortToastTouch(_ sender: UIButton) {
        SoftToast.show(text: "Short Toast Text")
    }
    
    @IBAction func webPopupTouch(_ sender: UIButton) {
        SoftWebPopup.popup(string: "https://naver.com")
    }
    
    @IBAction func indicatorTouch(_ sender: UIButton) {
        if #available(iOS 12.0, *) {
            SoftLoad.show(text: "Indicator")
        } else {
            SoftLoad.showWithNoStyle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SoftLoad.stop()
        }
    }
}
