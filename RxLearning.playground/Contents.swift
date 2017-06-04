//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

// RxSwift

// Observableの生成
// let myFirstObservable: Observable<Int> = Observable.create でも可
let myFirstObservable = Observable<Int>.create { observer in
    // イベントの排出、"1"という値をシーケンスに排出する
    observer.on(.next(1))
    observer.on(.next(5))
    // シーケンスの購読を終了させる
    observer.on(.completed)
    // Disposable: シーケンスの購読が終了するときに実行すべき処理を定義しておくことができる
    // 通信処理やDBアクセスなど外部のリソースを利用している場合にはここでリソースを解放する必要がある
    return Disposables.create()
}

// Observableの購読
// subscribe: 引数のクロージャーはシーケンスから排出されたイベントを引数としており、新しいイベントが排出されるたびに呼び出される
let subscription = myFirstObservable.subscribe { event in
    switch event {
    case .next(let element):
        print(element)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
}
subscription.dispose()
