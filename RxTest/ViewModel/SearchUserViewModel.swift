//
//  SearchUserViewModel.swift
//  RxTest
//
//  Created by Takao on 2017/05/18.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchUserViewModel {

    // usersとisLoadingの変更を購読させたいので、RxSwiftのVariableとして定義
    // ページが増えるごとにusersにuserのオブジェクトが追加されていく実装も想定しているので、Variableを利用
    let users: Variable<[GithubUser]> = Variable([GithubUser]())
    let totalCount: Variable<Int> = Variable(0)
    let isLoading: Variable<Bool> = Variable(false)
    let error: Variable<Error?> = Variable(nil)
    
    private(set) lazy var usersCountText: Observable<String> = Observable<String>.combineLatest(self.users.asObservable(), self.totalCount.asObservable()) {"\($0.count)/\($1)"}
    
    private var currentQuery: String? = nil
    private let perPage: Int = 20
    private var hasMoreUsers: Bool {
        guard users.value.count > 0 && totalCount.value > 0 else { return true}
        return users.value.count < totalCount.value
    }
    private var disposeBag: DisposeBag = DisposeBag()
    
    func fetchUsers(with query: String) {
        totalCount.value = 0
        users.value.removeAll()
        
        currentQuery = query
        
        // 通信開始の準備
        isLoading.value = true
        
        fetchMoreUsers()
    }
    
    // 追加取得を行う
    func fetchMoreUsers() {
        
        guard let currentQuery = currentQuery, !currentQuery.isEmpty, hasMoreUsers else {
            isLoading.value = false
            return
        }
        
        disposeBag = DisposeBag()
        let page = Int(users.value.count / perPage) + 1
        let request = GithubSearchUserRequest(query: currentQuery, page: page, perPage: perPage)
        
        GithubSession.send(request)
            .do(onCompleted: {[unowned self] in
                // 通信完了時に行いたい処理
                self.isLoading.value = false
            })
            
            .do(onError: {[unowned self] error in
                // エラー時に行いたい処理
                self.isLoading.value = false
            })
            
            .subscribe(onNext: {[unowned self] response in
                // response.valueでGithubUserの配列を受け取るので、users.valueに取得した配列を追加
                self.users.value += response.value
            })
            .addDisposableTo(disposeBag)
    }
    
}
