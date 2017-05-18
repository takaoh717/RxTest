//
//  GithubUser.swift
//  RxTest
//
//  Created by Takao on 2017/05/17.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import Himotoki

struct GithubUser: Decodable {
    // GithubAPIのレスポンスで返ってくるユーザ情報が入っている型の中で使用するものを定義
    let login: String // ユーザー名
    let avatarUrl: String // サムネイル
    let htmlUrl: String // ユーザページリンク
    
    // Decodable protocolによってdecode(_:)の実装が強制されている
    static func decode(_ e: Extractor) throws -> GithubUser {
        // 引数として渡されるExtractorの中から該当のキーの値を取得し、それらの値をもとにGithubUserを生成して返す
        return try GithubUser (login: e <| "login", avatarUrl: e <| "avatar_url", htmlUrl: e <| "html_url")
    }
}
