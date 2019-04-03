//
//  UIStoryboard+ViewController.swift
//  Cycling
//
//  Created by Jahid Hassan on 4/3/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

extension UIViewController {
    @discardableResult
    class func load<T: UIViewController>(from nib: String = String(describing: T.self)) -> T? {
        return T(nibName: nib, bundle: nil)
    }
}
