//
//  KeychainStore.swift
//  AIPhotoVideo
//
//  Created by Codex on 27/4/26.
//

import Foundation
import Security

protocol SecureStoreProtocol {
    func value<T: Decodable>(forKey key: String, as type: T.Type) -> T?
    @discardableResult
    func set<T: Encodable>(_ value: T, forKey key: String) -> Bool
    @discardableResult
    func removeValue(forKey key: String) -> Bool
}

final class KeychainStore: SecureStoreProtocol {
    private let service: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(service: String = Bundle.main.bundleIdentifier ?? "AIPhotoVideo") {
        self.service = service
    }
    
    func value<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        var query = baseQuery(forKey: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        
        do {
            return try decoder.decode(type, from: data)
        } catch {
            Common.showLog("Keychain decode failed for key \(key): \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func set<T: Encodable>(_ value: T, forKey key: String) -> Bool {
        do {
            let data = try encoder.encode(value)
            let query = baseQuery(forKey: key)
            let attributes: [String: Any] = [
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if status == errSecSuccess {
                return true
            }
            
            guard status == errSecItemNotFound else {
                Common.showLog("Keychain update failed for key \(key): \(status)")
                return false
            }
            
            var addQuery = query
            addQuery.merge(attributes) { _, new in new }
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            if addStatus != errSecSuccess {
                Common.showLog("Keychain add failed for key \(key): \(addStatus)")
            }
            return addStatus == errSecSuccess
        } catch {
            Common.showLog("Keychain encode failed for key \(key): \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func removeValue(forKey key: String) -> Bool {
        let status = SecItemDelete(baseQuery(forKey: key) as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    private func baseQuery(forKey key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }
}
