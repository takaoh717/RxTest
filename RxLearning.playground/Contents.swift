//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

// Playgroundで非同期処理の実行をできるようにする
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

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

print("----------------------")

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

print("----------------------")

// オペレータの利用
// map: Observerから排出される値を引数に取り、クロージャの中にその値を加工する処理を記述することができ、戻り値は新しいObservableになる
// myFirstObservableに数値が流れてきたら、その数値を5倍するシーケンス
let subscription1 = myFirstObservable.map{$0 * 5}.subscribe(onNext: { print("map: \($0)") })
subscription1.dispose()

print("----------------------")

// RxCocoaを使って、Github APIにリクエストを送信する
// 検索結果
struct SearchResult {
    let repos: [GithubRepository]
    let totalCount: Int
    init?(response:Any) {
        guard let response = response as? [String:Any], let reposDictionaries = response["items"] as? [[String:Any]], let count = response["total_count"] as? Int else { return nil }
        repos = reposDictionaries.flatMap{ GithubRepository(dictionary: $0) }
        totalCount = count
    }
}

// 検索結果のリポジトリ情報
struct GithubRepository {
    let name: String
    let starCount:Int
    init(dictionary:[String:Any]) {
        name = dictionary["full_name"] as! String
        starCount = dictionary["stargazers_count"] as! Int
    }
}

// 文字列を受け取って、Observableシーケンスを返す
///
///
/// - Parameter keyword: 検索キーワード
/// - Returns: SerchResult型を排出するObservableシーケンス
// このObservableシーケンスを購読することで、非同期に実行されるリポジトリ検索の結果を観測したり操作したりすることが可能になる
func searchRepos(keyword: String) -> Observable<SearchResult?> {
    let endPoint = "https://api.github.com"
    let path = "/search/repositories"
    let query = "?q=\(keyword)"
    let url = URL(string: endPoint + path + query)!
    let request = URLRequest(url: url)
    
    // rx.json(request:): 引数のURLRequestを実行し、レスポンスのJSONをデシリアライズし、結果をObservableシーケンスに排出してくれる
    // mapオペレータでAPIのレスポンス結果をAny型→SearchResult型に変換して新たにObservable<SearchResult>を生成する
    return URLSession.shared.rx.json(request: request).map{ SearchResult(response: $0)}
}

// SearchReposの戻り値であるObservableをsubscribeする
// subscribeした瞬間にAPI通信の非同期処理が実行され、処理が成功すればSearchResultの値がonNextの値としてシーケンスに排出される
let subscription2 = searchRepos(keyword: "RxSwift").subscribe(onNext: {print($0)})
