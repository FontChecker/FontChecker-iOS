//
//  Downloader.swift
//  FontChecker
//
//  Created by 김효원 on 27/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift

protocol Downloader {
    func createDirectory(dirName: String)
    func downloadFile(url: String) -> Observable<Result<Data, FTError>>
}
