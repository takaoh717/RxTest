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

class SearchUserViewController: UIViewController, Storyboardable {

    private let searchBar = UISearchBar(frame: .zero)
    private let searchCancelButton: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
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
        
    }
    
    private func configureTableView() {
        tableView.register(GithubUserCell.self)
    }
    
    // ViewModel内のpropertyの変更の購読を記述する
    private func configureObserver() {
        
        // ViewModel内のuserを購読して、更新があったときにUITableViewに反映するようにする
        // VariableをObservableではなくDriverに変換することによって、エラーによってシーケンスが終了せず、メインスレッドで実行が保証される
        // Driverに対して、 tableView.rx.items(cellIdentifier:cellType:)にバインドする
        // curriedArgumentでrow, user, cellが渡されるので、それらをもとにcellの要素の更新を行う
//        viewModel.users.asDriver().drive(tableView.rx.items(cellIdentifier: GithubUserCell.identifier, cellType: GithubUserCell.self), curriedArgument: { row, user, cell in cell.configure(with: user)}).addDisposableTo(disposeBag)
        
        // 検索バーによって入力された値を購読
        // 実現したい処理：文字の入力を0.3秒待って次の入力がなければ検索実行。同じ文字列だった場合は検索しない
        searchBar.rx.text.orEmpty.asDriver().skip(1).debounce(0.3).distinctUntilChanged().drive(onNext: {[unowned self] query in self.viewModel.fetchUsers(with: query)}).addDisposableTo(disposeBag)
        
        // ローディング状況をUIに反映する
        viewModel.isLoading.asDriver().drive(self.indicatorView.rx.isAnimating).addDisposableTo(disposeBag)
    }

}
