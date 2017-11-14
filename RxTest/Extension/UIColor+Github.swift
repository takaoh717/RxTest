//
//  UIColor+Github.swift
//  RxTest
//
//  Created by Takao on 2017/05/28.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    enum GithubColor {
        
        case gray
        case blue
        case textBlack
        case textGray
        
        var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            switch self {
            case .gray: return (245, 245, 245, 1)
            case .blue: return (64, 120, 192, 1)
            case .textBlack: return (51, 51, 51, 1)
            case .textGray: return (102, 102, 102, 1)
            }
        }
    }
    
    convenience init(github color: GithubColor) {
        let rgba = color.rgba
        self.init(red: rgba.red / 255.0, green: rgba.green / 255.0, blue: rgba.blue / 255.0, alpha: rgba.alpha)
    }
    
}
