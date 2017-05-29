//
//  UIKeyboardNotificationInfo.swift
//  RxTest
//
//  Created by Takao on 2017/05/30.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import UIKit

struct UIKeyboardNotificationInfo {
    let frame: CGRect
    let duration: TimeInterval
    let animationOptions: UIViewAnimationOptions
}

extension UIKeyboardNotificationInfo {
    init?(from notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt
        else { return nil }
        
        self.frame = rect.cgRectValue
        self.duration = duration
        self.animationOptions = UIViewAnimationOptions(rawValue: curve)
    }
}
