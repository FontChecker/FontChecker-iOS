//
//  MainModel.swift
//  FontChecker
//
//  Created by 김효원 on 30/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift

struct MainModel {
    let downloader: Downloader
    let fontManager: FontManager
    
    init(downloader: Downloader = DownloaderImpl(), fontManager: FontManager = FontManagerImpl()) {
        self.downloader = downloader
        self.fontManager = fontManager
    }
    
    func getDownloadFile(url: String) -> Observable<Result<String, FTError>> {
        return downloader.downloadFile(url: url)
    }
    
//    func getFontFile(localURL: String) -> Observable<Result<String, FTError>> {
//        return fontManager.installFont(filePath: localURL)
//    }
}
