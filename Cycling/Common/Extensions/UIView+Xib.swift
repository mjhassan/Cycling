//
//  UIView+Xib.swift
//  Cycling
//
//  Created by Jahid Hassan on 4/3/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    class func load<T: UIView>(from nib: String = String(describing: T.self)) -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T
    }
}
