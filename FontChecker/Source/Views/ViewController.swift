//
//  ViewController.swift
//  FontChecker
//
//  Created by 김효원 on 27/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController<Bindable>: UIViewController {
    var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: Bindable) { }

    func attribute() { }

    func layout() { }

    func initialize() {}
}
