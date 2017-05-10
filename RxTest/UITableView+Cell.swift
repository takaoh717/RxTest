//
//  UITableView+Cell.swift
//  RxTest
//
//  Created by Takao on 2017/05/10.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    // カスタムCellの登録及びリサイクル時にreuseIdentifirerが必要となるため
    // クラスに対して１つのレイアウトとして、identifierはクラス名を返すようにする
    static var identifier: String {
        return className
    }
}

// register: カスタムCellのTypeを渡すだけでUITableViewに登録できる
// dequeueReusableCell: カスタムCellのTypeを渡すだけでそのCellの型変換済みのインスタンスをUITableViewから取得できるようにする
extension UITableView {
    
    // カスタムCellの登録
    // Nibableを採用しているUITableViewCellのみを受け付ける
    // <T: UITableViewCell> -> UITableViewCellのType ParameterをTとしている
    func register<T: UITableViewCell>(_ cellType: T.Type) where T: Nibable {
        // T.nibのreuseIdentifierをT.identifierとして登録する
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    // コードでレイアウトが実装されているカスタムCellも登録することができるように
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    // UITableViewからカスタムCellを取得する
    func dequeueReusableCell<T: UITableViewCell>(with cellType: T.Type, for indexPath: IndexPath) -> T {
        // この時点では型がUITableViewCellになっているので、Tとして値を変換して返す
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
