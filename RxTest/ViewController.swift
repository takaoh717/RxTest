//
//  ViewController.swift
//  RxTest
//
//  Created by Takao on 2017/05/07.
//  Copyright © 2017年 TakaoHoriguchi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

