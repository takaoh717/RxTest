//
//  GithubRequest.swift
//  RxTest
//
//  Created by Takao on 2017/05/17.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import APIKit

protocol GithubRequest: Request {
    associatedtype Response: GithubResponse
}

extension GithubRequest {
    // protocolにこの形の変数の定義ができないので、extensionで定義
    var baseURL: URL {
        // GithubのURLを返すproperty
        return URL(string: "https://api.github.com")!
    }
}

