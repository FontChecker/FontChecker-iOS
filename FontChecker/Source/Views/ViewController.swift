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
import RxAppState
import Then
import SnapKit

protocol ViewBindable {
    var fontViewModel: FontViewBindable { get }
    var bgColorViewModel: ColorViewBindable { get }
    var textColorViewModel: ColorViewBindable { get }
    var attributes: PublishRelay<[NSAttributedString.Key: Any]> { get }
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
    let fontView = FontView()
    let bgColorView = ColorView()
    let textColorView = ColorView()

    var attributes = [NSAttributedString.Key: Any]()
    let buttonHeight: CGFloat = 60
    let bottomMargin: CGFloat = 30
    let bgColorHeight: CGFloat = 180

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func bind(_ viewModel: ViewBindable) {
        self.rx.viewWillAppear
            .subscribe(onNext: { _ in
                self.fontView.bind(viewModel.fontViewModel)
                self.bgColorView.bind(viewModel.bgColorViewModel)
                self.textColorView.bind(viewModel.textColorViewModel)
            })
            .disposed(by: disposeBag)

        Observable.merge(
            fontButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.fontView, self.buttonHeight) },
            bgColorButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.bgColorView, self.bgColorHeight) },
            textColorButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.textColorView, self.bgColorHeight) }
        )
            .subscribe(onNext: { (subview, height) in
                self.navigationItem.leftBarButtonItem = self.doneButton
                self.navigationItem.rightBarButtonItem = self.cancleButton
                self.view.addSubview(subview)
                subview.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(self.fontButton.snp.bottom)
                    $0.height.equalTo(height)
                }
            })
            .disposed(by: disposeBag)

        viewModel.attributes
            .subscribe(onNext: {
                self.attributes.updateValue($0.values.first!, forKey: $0.keys.first!)
                self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes)
            })
            .disposed(by: disposeBag)

        textView.rx.didChange
            .subscribe { _ in self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes) }
            .disposed(by: disposeBag)

        Observable.merge(
            doneButton.rx.tap.asObservable(),
            cancleButton.rx.tap.asObservable()
        )
            .subscribe(onNext: {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
                self.view.subviews.last?.removeFromSuperview()
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
        view.addHorizentalSubviews([fontButton, bgColorButton, textColorButton, sizeButton])

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
