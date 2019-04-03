//
//  Keychain.swift
//  Cycling
//
//  Created by Jahid Hassan on 4/3/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import Security

public struct Keychain {
    
    /// This is used to identifier your service
    public static let bundleIdentifier: String = {
        return Bundle.main.bundleIdentifier ?? ""
    }()
    
    /// Actions that can be performed with Keychain, mostly for handling secret
    enum Action {
        /// Insert an item into keychain
        case insert
        
        /// Fetch an item from keychain
        case fetch
        
        /// Delete an item from keychain
        case delete
    }
    
    // MARK: - Public methods
    
    /// Query secret using account in a Keychain service
    ///
    /// - Parameters:
    ///   - account: The account, this is for kSecAttrAccount
    ///   - service: The service, this is for kSecAttrService
    ///   - accessGroup: The access group, this is for kSecAttrAccessGroup
    /// - Returns: The secret
    public static func secret(forAccount account: String,
                                service: String = bundleIdentifier,
                                accessGroup: String = "") -> String? {
        guard !service.isEmpty && !account.isEmpty else {
            return nil
        }
        
        var query = [
            kSecAttrAccount as String : account,
            kSecAttrService as String : service,
            kSecClass as String : kSecClassGenericPassword] as [String : Any]
        
        if !accessGroup.isEmpty {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return Keychain.query(.fetch, query as [String : AnyObject]).1
    }
    
    
    /// Set the secret for the account in a Keychain service
    ///
    /// - Parameters:
    ///   - secret: The secret string you want to set
    ///   - account: The account, this is for kSecAttrAccount
    ///   - service: The service, this is for kSecAttrService
    ///   - accessGroup: The access group, this is for kSecAttrAccessGroup
    /// - Returns: True if the secret can be set successfully
    @discardableResult public static func setSecret(_ secret: String, forAccount account: String, service: String = bundleIdentifier, accessGroup: String = "") -> Bool {
        guard !service.isEmpty && !account.isEmpty else {
            return false
        }
        
        var query = [
            kSecAttrAccount as String : account,
            kSecAttrService as String : service,
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccessible as String : kSecAttrAccessibleAlways] as [String : Any]
        
        if !accessGroup.isEmpty {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return Keychain.query(.insert, query as [String : AnyObject], secret).0 == errSecSuccess
    }
    
    
    /// Delete secret for the account in a Keychain service
    ///
    /// - Parameters:
    ///   - account: The account, this is for kSecAttrAccount
    ///   - service: The service, this is for kSecAttrService
    /// - Returns: True if the secret can be safely deleted
    @discardableResult public static func deleteSecret(forAccount account: String, service: String = bundleIdentifier, accessGroup: String = "") -> Bool {
        guard !service.isEmpty && !account.isEmpty else {
            return false
        }
        
        var query = [
            kSecAttrAccount as String: account,
            kSecAttrService as String : service,
            kSecClass as String : kSecClassGenericPassword
            ] as [String : Any]
        
        if !accessGroup.isEmpty {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return Keychain.query(.delete, query as [String : AnyObject]).0 == errSecSuccess
    }
    
    // MARK: - Private methods
    
    /// A helper method to query Keychain based on some actions
    ///
    /// - Parameters:
    ///   - action: The action
    ///   - query: A dictionary containing keychain parameters
    ///   - secret: The secret
    /// - Returns: A tuple with status and returned secret
    fileprivate static func query(_ action: Action, _ query: [String : AnyObject], _ secret: String = "") -> (OSStatus, String) {
        let secretData = secret.data(using: String.Encoding.utf8)
        var returnSecret = ""
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        var attributes = [String : AnyObject]()
        
        switch action {
        case .insert:
            switch status {
            case errSecSuccess:
                attributes[kSecValueData as String] = secretData as AnyObject?
                status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            case errSecItemNotFound:
                var query = query
                query[kSecValueData as String] = secretData as AnyObject?
                status = SecItemAdd(query as CFDictionary, nil)
            default: break
            }
        case .fetch:
            var query = query
            query[kSecReturnData as String] = true as AnyObject?
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            
            var result: CFTypeRef?
            status = SecItemCopyMatching(query as CFDictionary, &result)
            
            if let result = result as? Data,
                let secret = String(data: result, encoding: String.Encoding.utf8) {
                returnSecret = secret
            }
        case .delete:
            status = SecItemDelete(query as CFDictionary)
        }
        
        return (status, returnSecret)
    }
}
