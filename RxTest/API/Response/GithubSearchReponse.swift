//
//  GithubSearchReponse.swift
//  RxTest
//
//  Created by Takao on 2017/05/17.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation

struct GithubSearchResponse<T>: GithubResponse {
    let value: [T] // 暗黙的にGithubResponse.ValueTypeが[T]になる
    let totalCount: Int
    let incompleteResults: Bool
}
