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

class SearchUserViewController: UIViewController {

    private let searchBar = UISearchBar(frame: .zero)
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
        
    }
    
    private func configureTableView() {
        
    }
    
    // ViewModel内のpropertyの変更の購読を記述する
    private func configureObserver() {
        
    }

}
