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

// GithubAPIの通信をラップするHTTPクライアント
struct GithubSession {
    // GenericFunctionのTをGithubRequestとすることで、ここで送信されるリクエストはGithubAPIの通信として縛ることができる
    // completionの引数をResult型として通信成功時にT.Response型、通信失敗時にSessionTaskError型を渡す
    static func send<T: GithubRequest>(_ request: T, completion: @escaping (Result<T.Response, SessionTaskError>)-> ()) {
        // APIKitのSessionのsendを使用して通信を行う
        // TはRequestProtocolを採用しているGithubRequestProtocolのため、completionをそのままhandlerに渡すことができる
        Session.send(request, callbackQueue: .main, handler: completion)
    }

}
