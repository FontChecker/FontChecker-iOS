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

    let lightButton = UIButton()
    let regularButton = UIButton()
    let boldButton = UIButton()
    
    let buttonLeading: CGFloat = 15
    let buttonBorderWidth: CGFloat = 0.7

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: ViewBindable) {
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
        self.do {
            $0.backgroundColor = .white
        }

        lightButton.do {
            $0.setTitle("light", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = buttonBorderWidth
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        regularButton.do {
            $0.setTitle("regular", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = buttonBorderWidth
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        boldButton.do {
            $0.setTitle("bold", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = buttonBorderWidth
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }

    func layout() {
        self.addSubview(lightButton)
        self.addSubview(regularButton)
        self.addSubview(boldButton)
        
        let buttonWidthRatio = Float(self.subviews.count) + 0.5
        
        lightButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(buttonWidthRatio)
            $0.top.bottom.height.equalToSuperview()
            $0.leading.equalToSuperview().inset(buttonLeading)
        }

        regularButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(buttonWidthRatio)
            $0.top.bottom.height.equalToSuperview()
            $0.leading.equalTo(lightButton.snp.trailing).offset(buttonLeading)
        }

        boldButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(buttonWidthRatio)
            $0.top.bottom.height.equalToSuperview()
            $0.leading.equalTo(regularButton.snp.trailing).offset(buttonLeading)
        }
    }
}
