//
//  File.swift
//  FontChecker
//
//  Created by 김효원 on 18/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FontView: UIView {
    let disposeBag = DisposeBag()

    let lightButton = FCButton()
    let regularButton = FCButton()
    let boldButton = FCButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: ViewModel) {
        Observable.merge(
            lightButton.rx.controlEvent(.touchUpInside).asObservable()
                .map{ UIFont.Weight.light },
            regularButton.rx.controlEvent(.touchUpInside).asObservable()
                .map{ UIFont.Weight.regular },
            boldButton.rx.controlEvent(.touchUpInside).asObservable()
                .map{ UIFont.Weight.bold }
        )
        .bind(to: viewModel.fontData)
        .disposed(by: disposeBag)
    }

    func attribute() {
        self.backgroundColor = .white

        lightButton.setTitle("light", for: .normal)
        regularButton.setTitle("regular", for: .normal)
        boldButton.setTitle("bold", for: .normal)
    }

    func layout() {
        self.addEqaulRatioSubviews([lightButton, regularButton, boldButton], ratio: 0.5, margin: 15)
        
        _ = [lightButton, regularButton, boldButton].map {
            $0.snp.makeConstraints {
                $0.top.bottom.height.equalToSuperview()
            }
        }
    }
}
