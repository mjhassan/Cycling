//
//  AppViewModel.swift
//  Cycling
//
//  Created by Jahid Hassan on 4/3/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

final class AppViewModel {
    // this is hilarious;
    // without `?? nil` compiler gives error
    static let shared = AppViewModel(UIApplication.shared.delegate?.window ?? nil)
    
    private weak var window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
    }
    
    func setInitialViewController() {
        guard let token = Keychain.secret(forAccount: "access_token"), token.isEmpty else {
            if let navigation = window?.rootViewController as? UINavigationController,
                !(navigation.viewControllers[0] is UserViewController) {
                window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
            
            return
        }
        
        guard let signinViewController: SigninViewController = UIViewController.load() else {
            return
        }
        
        window?.rootViewController = UINavigationController(rootViewController: signinViewController)
    }
}
