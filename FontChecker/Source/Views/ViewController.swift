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

    let fontButton = FCButton()
    let bgColorButton = FCButton()
    let textColorButton = FCButton()
    let sizeButton = FCButton()
    let textView = UITextView()
    let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: nil)
    let cancleButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: nil)

    let bottomMargin: CGFloat = 30
    let buttonHeight: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func bind(_ viewModel: ViewModel) {
        fontButton.rx.controlEvent(.touchUpInside).asObservable()
            .subscribe(onNext: { _ in
                self.navigationItem.leftBarButtonItem = self.doneButton
                self.navigationItem.rightBarButtonItem = self.cancleButton

                let fontView = FontView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.buttonHeight))
                fontView.bind(viewModel)
                self.view.addSubview(fontView)
                fontView.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(self.fontButton.snp.bottom)
                    $0.height.equalTo(self.buttonHeight)
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
            guard let fontView = (self.view.subviews.filter { $0 is FontView }).first else { return }
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

        fontButton.setTitle("폰트 변경", for: .normal)
        bgColorButton.setTitle("BG색", for: .normal)
        textColorButton.setTitle("TEXT색", for: .normal)
        sizeButton.setTitle("TEXT크기", for: .normal)
    }

    func layout() {
        view.addSubview(textView)
        view.addEqaulRatioSubviews([fontButton, bgColorButton, textColorButton, sizeButton])
        
        _ = [fontButton, bgColorButton, textColorButton, sizeButton].map {
            $0.snp.makeConstraints {
                $0.height.equalTo(buttonHeight)
                $0.bottom.equalToSuperview().inset(bottomMargin)
            }
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
