//
//  SearchUserViewController.swift
//  RxTest
//
//  Created by Takao on 2017/05/10.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Result

final class SearchUserViewController: UIViewController, Storyboardable {

    private let searchBar = UISearchBar(frame: .zero)
    private let searchCancelButton: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var alphaView: UIView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var totalCountContentView: UIView!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    // View以外のPropertyをViewModelに集約
    fileprivate let viewModel = SearchUserViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
        configureTableView()
        configureObserver()
    }
    
    private func configureNavigationView() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = searchCancelButton
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
        totalCountContentView.backgroundColor = UIColor(github: .gray)
        totalCountLabel.textColor = UIColor(github: .textBlack)
    }
    
    private func configureTableView() {
        tableView.contentInset.top = totalCountLabel.bounds.size.height
        tableView.scrollIndicatorInsets.top = totalCountContentView.bounds.size.height
        // セルの高さを自動で計算する
        tableView.rowHeight = UITableViewAutomaticDimension
        // StoryBoard上のセルの高さを入力
        tableView.estimatedRowHeight = GithubUserCell.defaultHeight
        // カスタムセルの登録
        tableView.register(GithubUserCell.self)
    }
    
    // ViewModel内のpropertyの変更の購読を記述する
    private func configureObserver() {
        
        // ViewModel内のuserを購読して、更新があったときにUITableViewに反映するようにする
        // VariableをObservableではなくDriverに変換することによって、エラーによってシーケンスが終了せず、メインスレッドで実行が保証される
        // Driverに対して、 tableView.rx.items(cellIdentifier:cellType:)にバインドする
        // curriedArgumentでrow, user, cellが渡されるので、それらをもとにcellの要素の更新を行う
        viewModel.users.asDriver().drive(tableView.rx.items(cellIdentifier: GithubUserCell.className, cellType: GithubUserCell.self)) {_, user, cell in
            cell.configure(with: user)
        }
        .addDisposableTo(disposeBag)
        
        // 検索バーによって入力された値を購読
        // 実現したい処理：文字の入力を0.3秒待って次の入力がなければ検索実行。同じ文字列だった場合は検索しない
        searchBar.rx.text.orEmpty.asDriver().skip(1).debounce(0.3).distinctUntilChanged().drive(onNext: {[unowned self] query in self.viewModel.fetchUsers(with: query)}).addDisposableTo(disposeBag)
        
        // 一番したまでスクロールしたら追加取得
        tableView.rx.reachedBottom
            .subscribe(onNext: { [unowned self] in
                self.viewModel.fetchMoreUsers()
            })
        .addDisposableTo(disposeBag)
        
        // ローディング状況をUIに反映する
        viewModel.isLoading.asDriver().drive(onNext: { [unowned self] isLoading in
            self.alphaView.isHidden = !isLoading
            self.indicatorView.isHidden = !isLoading
            self.indicatorView.rx.isAnimating.on(.next(isLoading))
        }).addDisposableTo(disposeBag)
        
        // カウントラベルの更新
        viewModel.usersCountText.asDriver(onErrorDriveWith: .empty())
        .drive(totalCountLabel.rx.text)
        .addDisposableTo(disposeBag)
        
        // ViewModelで起きたエラー時の処理
        viewModel.error.asDriver()
        .drive(onNext: { [unowned self] error in
            guard let error = error else { return }
            self.showAlert(with: error)
        })
        .addDisposableTo(disposeBag)
        
        // 検索キャンセルボタンの更新購読
        searchCancelButton.rx.tap.asDriver()
        .drive(onNext: { [unowned self] in
            self.searchBar.resignFirstResponder()
        })
        .addDisposableTo(disposeBag)
        
//        NotificationCenter.default.rx.notification(.UIKeyboardWillShow).asDriver(onErrorDriveWith: .empty())
//            .flatMap { notification -> Driver<UIKeyboardNotificationInfo> in
//                guard let keyboardInfo = UIKeyboardNotificationInfo(from: notification) else {
//                    return Driver.empty()
//                }
//                return Driver.just(keyboardInfo)
//        }
//            .drive(onNext: { [unowned self] info in
//                
//            })
    }
    
    
    private func showAlert(with error: Error) {
        if presentedViewController is UIAlertController { return }
        let alertVC = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}
