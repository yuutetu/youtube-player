//
//  MusicItemCollectionViewCell.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2016/12/25.
//  Copyright © 2016年 Masayuki Kagae. All rights reserved.
//

import UIKit
import Haneke

class MusicItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    func setup(with movie: Movie) {
        titleLabel.text = movie.title
        thumbnailImageView.hnk_setImage(from: movie.thumbnail?.url)
    }
}
