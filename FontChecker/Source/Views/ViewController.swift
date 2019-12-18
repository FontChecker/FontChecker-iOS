//
//  ViewController.swift
//  FontChecker
//
//  Created by 김효원 on 17/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

protocol ViewBindable {
    var fontData: PublishRelay<UIFont.Weight> { get }
}

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    let fontButton = UIButton()
    let bgColorButton = UIButton()
    let textColorButton = UIButton()
    let sizeButton = UIButton()
    let textView = UITextView()

    let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: nil)
    let cancleButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func bind(_ viewModel: ViewBindable) {
        fontButton.rx.controlEvent(.touchUpInside).asObservable()
            .subscribe(onNext: { _ in
                self.navigationItem.leftBarButtonItem = self.doneButton
                self.navigationItem.rightBarButtonItem = self.cancleButton

                let fontView = FontView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
                let model = viewModel
                fontView.bind(model)

                self.view.addSubview(fontView)
                fontView.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(self.fontButton.snp.bottom)
                    $0.height.equalTo(60)
                }
            })
            .disposed(by: disposeBag)

        viewModel.fontData.asObservable()
            .subscribe(onNext: {
                self.textView.font = UIFont.systemFont(ofSize: 15, weight: $0)
            })
            .disposed(by: disposeBag)

        Observable.merge(
            doneButton.rx.tap.asObservable(),
            cancleButton.rx.tap.asObservable()
        )
        .subscribe(onNext: {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            guard let fontView = (self.view.subviews.filter { $0 is FontView }).first else {
                return
            }
            fontView.removeFromSuperview()
        })
        .disposed(by: disposeBag)
    }

    func attribute() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Font Checker"

        textView.do {
            $0.backgroundColor = .white
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }

        fontButton.do {
            $0.setTitle("폰트변경", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        bgColorButton.do {
            $0.setTitle("BG색", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        textColorButton.do {
            $0.setTitle("TEXT색", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        sizeButton.do {
            $0.setTitle("TEXT크기", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }

    func layout() {
        view.addSubview(textView)
        view.addSubview(fontButton)
        view.addSubview(bgColorButton)
        view.addSubview(textColorButton)
        view.addSubview(sizeButton)

        fontButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalToSuperview()
        }

        bgColorButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalTo(fontButton.snp.trailing)
            $0.trailing.equalTo(textColorButton.snp.leading)
        }

        textColorButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalTo(bgColorButton.snp.trailing)
            $0.trailing.equalTo(sizeButton.snp.leading)
        }

        sizeButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview()
        }

        let safeAreaInsetsTop = (UIApplication.shared.windows.first { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
        let height = (navigationController?.navigationBar.bounds.height ?? 0) + safeAreaInsetsTop
        textView.snp.makeConstraints {
            $0.top.equalTo(height)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(fontButton.snp.top)
        }
    }
}
