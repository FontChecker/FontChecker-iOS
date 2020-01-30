//
//  MainViewModel.swift
//  FontChecker
//
//  Created by 김효원 on 18/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel: MainViewBindable {
    let disposeBag = DisposeBag()

    let fontViewModel: FontViewBindable
    let bgColorViewModel: ColorViewBindable
    let textColorViewModel: ColorViewBindable
    let sizeViewModel: SizeViewBindable
    
    let downloadURL = PublishRelay<String>()
    let resultMessage: Signal<String>

    var attributes = PublishRelay<[NSAttributedString.Key: Any]>()
    
    init(model: MainModel = MainModel()) {
        self.fontViewModel = FontViewModel()
        self.bgColorViewModel = ColorViewModel()
        self.textColorViewModel = ColorViewModel()
        self.sizeViewModel = SizeViewModel()

        let fontChange = Observable.combineLatest(
            fontViewModel.fontData.asObservable().startWith(UIConstant.Base.font.familyName),
            sizeViewModel.sizeData.asObservable().startWith(UIConstant.Base.fontSize))
            .map { (font, size) -> [NSAttributedString.Key: Any] in
                return [NSAttributedString.Key.font: UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)]
            }

        Observable.merge(
            fontChange,
            bgColorViewModel.colorData.asObservable().map{ [NSAttributedString.Key.backgroundColor: $0] },
            textColorViewModel.colorData.asObservable().map{ [NSAttributedString.Key.foregroundColor: $0] })
            .bind(to: attributes)
            .disposed(by: disposeBag)

        let fileDownload = downloadURL
            .flatMap(model.getDownloadFile(url:))
            .asObservable()
            .share()
        
        fileDownload
            .map { result -> String? in
                guard case .success(let url) = result else {
                    return nil
                }
                return url
            }
            .filterNil()
            .subscribe { event in
                guard let url = event.element else { return }
                model.fontManager.setCustomFonts(fontURL: url)
            }
            .disposed(by: disposeBag)

        let fileDownloadError = fileDownload
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
        self.resultMessage = Observable
            .merge(fileDownloadError)
            .asSignal(onErrorJustReturn: FTError.defaultError.message ?? "")
    }
}
