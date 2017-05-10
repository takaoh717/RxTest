//
//  Storybordable.swift
//  RxTest
//
//  Created by Takao on 2017/05/10.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import UIKit

protocol Storyboardable: NSObjectProtocol {
    static var storyboardName: String { get }
    static func instantiate() -> Self
}

// where Self: UIViewController -> StoryboardableUIViewControllerの性質を持っていることを明記
//  ->Storyboardからインスタンス化したUIViewControllerがStoryboardableを適用しているUIViewControllerのサブクラスの型として返すことができる
extension Storyboardable where Self: UIViewController {
    // Storyboard名とUIViewControllerのサブクラス名が異なる場合に、クラス名と異なる名前を返すことができるようにする
    static var storyboardName: String {
        return className
    }
    
    // StoryboardからUIViewControllerのインスタンス化をできるようにする
    static func instantiate() -> Self {
        return UIStoryboard(name: storyboardName, bundle: .main).instantiateInitialViewController() as! Self
    }
}
