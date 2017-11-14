//
//  GithubSearchUserRequest.swift
//  RxTest
//
//  Created by Takao on 2017/05/17.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

struct GithubSearchUserRequest: GithubRequest {
    // Githubの検索APIが返すオブジェクトはユーザ情報の配列のため、配列の中身の型をGithubUserにする
    typealias Response = GithubSearchResponse<GithubUser>
    
    // 検索APIで必要なクエリパラメータ
    let query: String
    let page: Int
    let perPage: Int
    
    // RequestProtocolによって定義されている
    // 検索APIに必要な値を入れる
    let method: HTTPMethod = .get
    let path: String = "/search/users"
    var queryParameters: [String : Any]? {
        // 適切なキーに対して定義されている値をそれぞれ返す
        return ["q":query, "page":page, "per_page":perPage]
    }
    
    // 検索APIのレスポンスとして、items, total_count, incomplete_resultsがキーとなった辞書配列が返ってくるので、それらを適切な型に変換し、返す
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let totalCount: Int = try decodeValue(object, rootKeyPath: "total_count")
        let ir: Bool = try decodeValue(object, rootKeyPath: "incomplete_results")
        let users: [GithubUser] = try decodeArray(object, rootKeyPath: "items")
        return GithubSearchResponse(value: users, totalCount: totalCount, incompleteResults: ir)
    }
    
}
