//
//  MainViewController.swift
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

protocol MainViewBindable {
    var fontViewModel: FontViewBindable { get }
    var bgColorViewModel: ColorViewBindable { get }
    var textColorViewModel: ColorViewBindable { get }
    var sizeViewModel: SizeViewBindable { get }
    var lineViewModel: SizeViewBindable { get }
    var letterViewModel: SizeViewBindable { get }
    var attributes: PublishRelay<[NSAttributedString.Key: Any]> { get }
    var downloadURL: PublishRelay<String> { get }
    var resultMessage: Signal<String> { get }
}

class MainViewController: ViewController<MainViewBindable> {
    let settingView = UIScrollView()
    let textView = UITextView()
    let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: nil)
    let cancleButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: nil)
    let indicator = UIActivityIndicatorView()
    
    let fontButton = FCButton()
    let bgColorButton = FCButton()
    let textColorButton = FCButton()
    let sizeButton = FCButton()
    let addFontButton = FCButton()
    let lineButton = FCButton()
    let letterButton = FCButton()
    let fontView = FontView()
    let bgColorView = ColorView()
    let textColorView = ColorView()
    let sizeView = SizeView()
    let lineView = SizeView()
    let letterView = SizeView()
    
    private typealias UI = Constant.UI.Main
    
    var tempAttributes = [NSAttributedString.Key: Any]()
    var attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: Constant.UI.Base.fontSize),
        NSAttributedString.Key.backgroundColor: UIColor.white,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: NSParagraphStyle(),
        NSAttributedString.Key.kern: 0
    ]

    override func bind(_ viewModel: MainViewBindable) {
        self.disposeBag = DisposeBag()
        
        bindToViewModel(viewModel)
        bindToView(viewModel)

        Observable.merge(
            fontButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.fontView, Constant.UI.Font.height) },
            bgColorButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.bgColorView, Constant.UI.Color.height) },
            textColorButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.textColorView, Constant.UI.Color.height) },
            lineButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.lineView, Constant.UI.Size.height) },
            letterButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.letterView, Constant.UI.Size.height) },
            sizeButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.sizeView, Constant.UI.Size.height) })
            .subscribe(onNext: { (subview, height) in
                self.tempAttributes = self.attributes
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
        
        addFontButton.rx.tap.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                let prompt = UIAlertController(title: "다운받을 URL 입력해주세요", message: nil, preferredStyle: .alert)
                prompt.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                prompt.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Input URL for download .otf file..."
                })
                prompt.addAction(UIAlertAction(title: "다운로드", style: .default, handler: { _ in
                    if let url = prompt.textFields?.first?.text {
                        viewModel.downloadURL.accept(url)
                        self?.indicator.startAnimating()
                        self?.indicator.isHidden = false
                    }
                }))
                
                self?.present(prompt, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        textView.rx.didChange
            .subscribe { _ in self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes) }
            .disposed(by: disposeBag)
    }
    
    func bindToView(_ viewModel: MainViewBindable) {
        viewModel.attributes
            .subscribe(onNext: {
                _ = $0.map { key, value in
                    self.attributes.updateValue(value, forKey: key)
                    self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.resultMessage
            .emit(to: self.rx.notify())
            .disposed(by: disposeBag)
    }
    
    func bindToViewModel(_ viewModel: MainViewBindable) {
        self.rx.viewWillAppear
            .subscribe(onNext: { _ in
                self.fontView.bind(viewModel.fontViewModel)
                self.bgColorView.bind(viewModel.bgColorViewModel)
                self.textColorView.bind(viewModel.textColorViewModel)
                self.sizeView.bind(viewModel.sizeViewModel)
                self.lineView.bind(viewModel.lineViewModel)
                self.letterView.bind(viewModel.letterViewModel)
                self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes)
            })
            .disposed(by: disposeBag)
        
        fontButton.rx.controlEvent(.touchUpInside).asObservable()
            .map{ _ in FontManagerImpl.shared.getFontList() }
            .bind(to: viewModel.fontViewModel.reloadFonts)
            .disposed(by: disposeBag)
        
        Observable.merge( doneButton.rx.tap.asObservable().map { return true }, cancleButton.rx.tap.asObservable().map { return false })
            .subscribe(onNext: {
                if !($0) { viewModel.attributes.accept(self.tempAttributes) }
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
                self.view.subviews.last?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }

    override func attribute() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Font Checker"

        textView.do {
            $0.backgroundColor = .white
            $0.font = Constant.UI.Base.font
        }

        settingView.do {
            $0.backgroundColor = UI.backgroundColor
            $0.showsHorizontalScrollIndicator = false
        }

        fontButton.setTitle("폰트 변경", for: .normal)
        bgColorButton.setTitle("BG색", for: .normal)
        textColorButton.setTitle("TEXT색", for: .normal)
        sizeButton.setTitle("TEXT크기", for: .normal)
        lineButton.setTitle("행간 크기", for: .normal)
        letterButton.setTitle("자간 크기", for: .normal)
        addFontButton.setTitle("폰트 추가", for: .normal)
    }

    override func layout() {
        view.addSubview(textView)
        let buttonViews = [fontButton, addFontButton, bgColorButton, textColorButton, sizeButton, lineButton, letterButton]
        let cnt = CGFloat(buttonViews.count)
        settingView.addHorizentalSubviews(buttonViews, ratio: (cnt * UI.leftRatio), margin: UI.leftMargin)
        settingView.contentSize = CGSize(width: (view.frame.width / (cnt + (cnt * UI.leftRatio))) * cnt + (UI.leftMargin * cnt), height: settingView.bounds.height)
        view.addSubview(settingView)

        settingView.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.height.equalTo(UI.height)
        }

        _ = buttonViews.map {
            $0.snp.makeConstraints {
                $0.height.equalTo(UI.buttonHeight)
                $0.top.equalToSuperview().inset(UI.topMargin)
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
