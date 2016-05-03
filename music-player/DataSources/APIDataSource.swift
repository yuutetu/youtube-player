//
//  APIDataSource.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/05/03.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Foundation
import RxSwift

class APIDataSource<ItemType: APIModel where ItemType.DecodedType == ItemType> {
    let disposeBag = DisposeBag()
    private(set) var models: Variable<[ItemType]> = Variable([ItemType]())
    let request: YoutubeAPIRequest
    private(set) var nextPageToken: String?
    
    init(request: YoutubeAPIRequest) {
        self.request = request
    }
    
    func load() {
        YoutubeApiClient.defaultClient.request(request).subscribe({ event in
            switch event {
            case .Next(let element):
                // 一覧データセット
                switch element.0 {
                case .Success(let movies) where movies is APIMultipleResponse<ItemType>:
                    self.models.value = (movies as! APIMultipleResponse<ItemType>).items
                    self.nextPageToken = (movies as! APIMultipleResponse<ItemType>).nextPageToken
                case .Success:
                    // エラー文章セット
                    break
                case .Failure:
                    // エラー文章セット
                    break
                }
            case .Completed:
                // isLoading = false
                break
            case .Error(let error):
                self.models.value = []
                // エラー文章セット
                // isLoading = false
                print(error)
            }
        }).addDisposableTo(disposeBag)
    }
    
    func reload() {
        load()
    }
    
    func next() {
        guard let nextPageToken = nextPageToken else {
            load()
            return
        }
        
        YoutubeApiClient.defaultClient.request(request, pageToken: nextPageToken).subscribe({ event in
            switch event {
            case .Next(let element):
                // 一覧データセット
                switch element.0 {
                case .Success(let movies) where movies is APIMultipleResponse<ItemType>:
                    self.models.value += (movies as! APIMultipleResponse<ItemType>).items
                    self.nextPageToken = (movies as! APIMultipleResponse<ItemType>).nextPageToken
                case .Success:
                    // エラー文章セット
                    break
                case .Failure:
                    // エラー文章セット
                    break
                }
            case .Completed:
                // isLoading = false
                break
            case .Error(let error):
                self.models.value = []
                // エラー文章セット
                // isLoading = false
                print(error)
            }
        }).addDisposableTo(disposeBag)
    }
}
