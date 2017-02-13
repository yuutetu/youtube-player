//
//  StyleableView.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit

@IBDesignable class StyleableView: UIView {
    @IBInspectable var borderUIColor: UIColor? {
        set {
            layer.borderColor = borderUIColor?.cgColor
        }
        get {
            guard let borderCGColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderCGColor)
        }
    }
}

@IBDesignable class StyleableImageView: UIImageView {
    @IBInspectable var borderUIColor: UIColor? {
        set {
            layer.borderColor = borderUIColor?.cgColor
        }
        get {
            guard let borderCGColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderCGColor)
        }
    }
}
