//
//  DownloaderImpl.swift
//  FontChecker
//
//  Created by 김효원 on 30/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DownloaderImpl: Downloader {
    private let fileManager: FileManager
    private let session: URLSession

    init(session: URLSession = .shared, fileManager: FileManager = .default) {
        self.session = session
        self.fileManager = fileManager
    }

    func createDirectory(dirName: String = FileConstant.Path.baseDirName){
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent(dirName)
        if fileManager.fileExists(atPath: directoryURL.path) { return }

        do {
            try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            NSLog("Directory 생성 실패")
        }
    }

    func downloadFile(url: String) -> Observable<Result<Data, FTError>> {
        guard let url = URLComponents(string: url)?.url else {
            let error = FTError.error("유효하지 않은 URL입니다.")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let response = try JSONDecoder().decode(Data.self, from: data)
                    return .success(response)
                } catch {
                    return .failure(.error("파일 다운로드 실패"))
                }
        }
    }
}
