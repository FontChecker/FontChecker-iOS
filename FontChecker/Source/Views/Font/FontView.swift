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

class FontView: UIScrollView {
    let disposeBag = DisposeBag()

    let lightButton = UIButton()
    let regularButton = UIButton()
    let boldButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: ViewBindable) {
        lightButton.rx.controlEvent(.touchUpInside).asObservable()
            .map { _ in
                self.removeFromSuperview()
                return UIFont.Weight.light
            }
            .bind(to: viewModel.fontData)
            .disposed(by: disposeBag)

        regularButton.rx.controlEvent(.touchUpInside).asObservable()
            .map { _ in
                self.removeFromSuperview()
                return UIFont.Weight.regular
            }
            .bind(to: viewModel.fontData)
            .disposed(by: disposeBag)

        boldButton.rx.controlEvent(.touchUpInside).asObservable()
            .map { _ in
                self.removeFromSuperview()
                return UIFont.Weight.bold
            }
            .bind(to: viewModel.fontData)
            .disposed(by: disposeBag)
    }

    func attribute() {
        self.do {
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .white
        }

        lightButton.do {
            $0.setTitle("light", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        regularButton.do {
            $0.setTitle("regular", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        boldButton.do {
            $0.setTitle("bold", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }

    func layout() {
        self.addSubview(lightButton)
        self.addSubview(regularButton)
        self.addSubview(boldButton)

        lightButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.bottom.leading.equalToSuperview()
        }

        regularButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.leading.equalTo(lightButton.snp.trailing)
            $0.trailing.equalTo(boldButton.snp.leading)
        }

        boldButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(3)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}
