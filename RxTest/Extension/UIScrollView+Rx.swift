//
//  UIScrollView+Rx.swift
//  RxTest
//
//  Created by Takao on 2017/05/28.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: UIScrollView {

    // UIScrolliewが最下部に到達したかを判断する
    var reachedBottom: Observable<Void> {
        let observable: Observable<Bool> = contentOffset
            .map { [weak base] contentOffset in
                guard let scrollView = base else { return false }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold

        }
        .distinctUntilChanged()
            .filter { $0 }
        return observable.map { _ in () }
    }
}
