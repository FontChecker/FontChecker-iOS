//
//  ViewController.swift
//  FontChecker
//
//  Created by 김효원 on 19/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit

class ViewController<ViewBindable>: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func bind(_ viewModel: ViewBindable) { }

    func attribute() { }

    func layout() { }
}
