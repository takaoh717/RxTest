//
//  NSObjectProtocol+ClassName.swift
//  RxTest
//
//  Created by Takao on 2017/05/10.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    // Storyboardからクラス名指定でインスタンスを取得できるようにするために自分のクラス名を返す
    static var className: String {
        return String(describing: self)
    }
}
