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
    let lineViewModel: SizeViewBindable
    
    let downloadURL = PublishRelay<String>()
    let resultMessage: Signal<String>

    var attributes = PublishRelay<[NSAttributedString.Key: Any]>()
    
    private typealias UI = Constant.UI
    
    init(model: MainModel = MainModel()) {
        self.fontViewModel = FontViewModel()
        self.bgColorViewModel = ColorViewModel()
        self.textColorViewModel = ColorViewModel()
        self.sizeViewModel = SizeViewModel()
        self.lineViewModel = SizeViewModel()

        let fontChange = Observable.combineLatest(
            fontViewModel.fontData.asObservable().startWith(UI.Base.font.familyName),
            sizeViewModel.sizeData.asObservable().startWith(UI.Base.fontSize))
            .map { (font, size) -> [NSAttributedString.Key: Any] in
                return [NSAttributedString.Key.font: UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)]
            }

        Observable.merge(
            fontChange,
            bgColorViewModel.colorData.asObservable().map{ [NSAttributedString.Key.backgroundColor: $0] },
            lineViewModel.sizeData.asObservable().map{
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = $0
                return [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            },
            textColorViewModel.colorData.asObservable().map{ [NSAttributedString.Key.foregroundColor: $0] })
            .bind(to: attributes)
            .disposed(by: disposeBag)

        let fileDownload = downloadURL
            .flatMap(model.getDownloadFile(url:))
            .asObservable()
            .share()
        
        let fileDownloadResult = fileDownload
            .map { result -> String? in
                guard case .success(let url) = result else {
                    return nil
                }
                return url
            }
            .filterNil()
        
        fileDownloadResult
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
            .merge(fileDownloadError, fileDownloadResult.map{ _ in "폰트 다운로드 성공" })
            .asSignal(onErrorJustReturn: FTError.defaultError.message ?? "")
    }
}
