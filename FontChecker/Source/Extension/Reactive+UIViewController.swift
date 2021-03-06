//
//  Reactive+UIViewController.swift
//  FontChecker
//
//  Created by 김효원 on 30/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    func notify() -> Binder<String> {
        return Binder(base) { base, message in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인".localizedCapitalized, style: .destructive, handler: nil)
            alert.addAction(okAction)
            base.present(alert, animated: true, completion: nil)
        }
    }
}
