//
//  ViewController.swift
//  Cycling
//
//  Created by Jahid Hassan on 4/3/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

