//
//  SigninViewController.swift
//  Cycling
//
//  Created by Jahid Hassan on 4/3/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func pressedSignin(_ sender: UIButton) {
        Keychain.setSecret("Olo", forAccount: "access_token")
        AppViewModel.shared.setInitialViewController()
    }
}
