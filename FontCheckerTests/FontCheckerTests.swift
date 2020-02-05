//
//  FontCheckerTests.swift
//  FontCheckerTests
//
//  Created by 김효원 on 17/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import XCTest
import RxSwift
@testable import FontChecker

class FontCheckerTests: XCTestCase {
    let disposeBag = DisposeBag()
    var viewModel: MainViewModel!
    var model: MainModel!

    override func setUp() {
        self.model = MainModel(downloader: DownloaderImpl(), fontManager: FontManagerImpl())
        self.viewModel = MainViewModel(model: model)
    }

    func testAddCustomFont() {
        model.getDownloadFile(url: "http://pop.baemin.com/fonts/jua/BMJUA_otf.otf")
            .subscribe(onNext: { result in
                let url = try? result.get()
                assert(url != nil, "Custom Font Download Getting Success")
            })
            .disposed(by: disposeBag)
    }
    
    func testChangeFont() {
        viewModel.fontViewModel.fontData
            .subscribe(onNext: { fontName in
                assert(fontName == "BMJUA_otf", "Change Font Getting Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.fontViewModel.fontData.accept("BMJUA_otf")
    }
    
    func testTextColorChange() {
        viewModel.textColorViewModel.colorData.startWith(UIColor.red)
            .subscribe(onNext: { textColor in
                assert(textColor == UIColor.red, "Change Text Color Getting Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.textColorViewModel.colorData.accept(UIColor.red)
    }

    func testBackgroundColorChange() {
        viewModel.bgColorViewModel.colorData
            .subscribe(onNext: { textColor in
                assert(textColor == UIColor.blue, "Change Background Color Getting Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.bgColorViewModel.colorData.accept(UIColor.blue)
    }
    
    func testTextSizeChange() {
        viewModel.sizeViewModel.sizeData
            .subscribe(onNext: { size in
                assert(size == 15, "Change Text Size Getting Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.sizeViewModel.sizeData.accept(15)
    }
    
    func testLinesSpaceChange() {
        viewModel.lineViewModel.sizeData
            .subscribe(onNext: { size in
                assert(size == 10, "Change Line Size Getting Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.lineViewModel.sizeData.accept(10)
    }
    
    func testLetterSpaceChange() {
        viewModel.letterViewModel.sizeData
            .subscribe(onNext: { size in
                assert(size == 8, "Change Letter Size Getting Success")
            })
            .disposed(by: disposeBag)
        
        viewModel.letterViewModel.sizeData.accept(8)
    }
}
