//
//  APIDataSource.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Foundation
import RxSwift

protocol DataSource: Sequence, Collection {
    associatedtype ItemType
    
    // extensionの方に置くとコンパイラー落ちるので…
    associatedtype Generator = AnyIterator<ItemType> // SequenceType用
    associatedtype Index = Int                        // CollectionType用
    
    var numberOfItems: Int { get }
    func itemAtIndex(index: Int) -> ItemType?
    
    func load()
    func next()
    // func reset()
}

extension DataSource {
    func reload() {
        load()
    }
    
    // MARK: - SequenceType
    
    func generate() -> AnyIterator<ItemType> {
        var index = 0
        return AnyIterator {
            let item = self.itemAtIndex(index: index)
            index += 1
            return item
        }
    }
    
    // MARK: - CollectionType
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return numberOfItems
    }
    
    subscript(i: Int) -> ItemType {
        return itemAtIndex(index: i)!
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
}

class APIDataSource<ItemType: APIModel>: DataSource {
    let disposeBag = DisposeBag()
    private(set) var models: Variable<[ItemType]> = Variable([ItemType]())
    let request: YoutubeAPIRequest
    private(set) var nextPageToken: String?
    
    var numberOfItems: Int {
        return models.value.count
    }
    
    init(request: YoutubeAPIRequest) {
        self.request = request
    }
    
    func itemAtIndex(index: Int) -> ItemType? {
        return models.value[index]
    }
    
    func load() {
        YoutubeAPIClient.default.request(request).subscribe({ event in
            switch event {
            case .next(let element):
                // 一覧データセット
                switch element.0 {
                case .success(let movies) where movies is APIMultipleResponse<ItemType>:
                    self.models.value = (movies as! APIMultipleResponse<ItemType>).items
                    self.nextPageToken = (movies as! APIMultipleResponse<ItemType>).nextPageToken
                case .success:
                    // エラー文章セット
                    break
                case .failure:
                    // エラー文章セット
                    break
                }
            case .completed:
                // isLoading = false
                break
            case .error(let error):
                self.models.value = []
                // エラー文章セット
                // isLoading = false
                print(error)
            }
        }).addDisposableTo(disposeBag)
    }
    
    func next() {
        guard let nextPageToken = nextPageToken else {
            load()
            return
        }
        
        YoutubeAPIClient.default.request(request, pageToken: nextPageToken).subscribe({ event in
            switch event {
            case .next(let element):
                // 一覧データセット
                switch element.0 {
                case .success(let movies) where movies is APIMultipleResponse<ItemType>:
                    self.models.value += (movies as! APIMultipleResponse<ItemType>).items
                    self.nextPageToken = (movies as! APIMultipleResponse<ItemType>).nextPageToken
                case .success:
                    // エラー文章セット
                    break
                case .failure:
                    // エラー文章セット
                    break
                }
            case .completed:
                // isLoading = false
                break
            case .error(let error):
                self.models.value = []
                // エラー文章セット
                // isLoading = false
                print(error)
            }
        }).addDisposableTo(disposeBag)
    }
}
