//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "icon-play")
image?.withRenderingMode(.alwaysTemplate)
let imageView = UIImageView(image: image)
imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
view.addSubview(imageView)