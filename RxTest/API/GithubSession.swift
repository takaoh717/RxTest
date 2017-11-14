//
//  GithubSession.swift
//  RxTest
//
//  Created by Takao on 2017/05/18.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import APIKit
import Result
import RxCocoa
import RxSwift

// GithubAPIの通信をラップするHTTPクライアント
struct GithubSession {
    // GenericFunctionのTをGithubRequestとすることで、ここで送信されるリクエストはGithubAPIの通信として縛ることができる
    // completionの引数をResult型として通信成功時にT.Response型、通信失敗時にSessionTaskError型を渡す
    static func send<T: GithubRequest>(_ request: T) -> Observable<T.Response> {

        // GithubRequest.Responseに対応するObservableを作成
        // create内で通信処理を行う
        let observable = Observable<T.Response>.create { observer in
            // APIKitのSessionのsendを使用して通信を行う
            // TはRequestProtocolを採用しているGithubRequestProtocolのため、completionをそのままhandlerに渡すことができる
            let task = Session.send(request, callbackQueue: .main, handler: { result in
                switch result {
                case .success(let value):
                    // resonseの取得に成功した場合はobserverに取得結果を渡して完了
                    observer.on(.next(value))
                    observer.onCompleted()
                case .failure(let error):
                    // Errorの場合はobserverにエラーを渡す
                    observer.onError(error)
                }
            })

            // Disposableを生成する際にtaskのキャンセル処理を記述し、dispose時にtaskをキャンセルするようにする
            return Disposables.create(with: {
                task?.cancel()
            })
        }
        // observableはsendメソッドが呼ばれるたびに生成されるので、一つ目のobserverのみ取得するようにする
        return observable.take(1)
    }


    static func cancelRequest<T:Request>(with type: T.Type) {
        Session.cancelRequests(with: type)
    }
}
