//
//  GithubResponse.swift
//  RxTest
//
//  Created by Takao on 2017/05/17.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation

// APIのレスポンスをラップするためのprotocol
// Github APIからのレスポンスがさまざまな型として返されるため、その型に合わせるためのラッパー
protocol GithubResponse {
    
    // associatedtype（連想型）: プロトコルの準拠時に型を指定できる。一つの型に依存しないプロトコルを定義できる
    associatedtype Valuetype
    var value: Valuetype { get }
}
