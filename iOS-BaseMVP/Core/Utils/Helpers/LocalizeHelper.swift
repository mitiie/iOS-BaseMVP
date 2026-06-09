//
//  LocalizeHelper.swift
//  SwiftCommon
//
//  Created by mitie on 17/02/2023.
//

import Foundation
import UIKit

class LocalizeHelper: NSObject {
    
    static let shared = LocalizeHelper()
    
    private enum Keys {
        static let selectedLanguageCode = "selectedLanguageCode"
    }
    
    private var bundle: Bundle = Bundle.main
    private var lang: LanguageModel?
    private var defaultLanguage = LanguageModel(
        name: "English",
        code: "en",
        display: "English",
        flag: "ic_flag_en"
    )
    
    override init() {
        super.init()
        let allLanguages = LocalizeHelper.generateLanguages()
        if let savedCode = UserDefaults.standard.string(forKey: Keys.selectedLanguageCode),
           let savedLanguage = allLanguages.first(where: { $0.code == savedCode }) {
            applyLanguage(savedLanguage)
            self.lang = savedLanguage
        } else {
            let systemCode = Locale.current.language.languageCode?.identifier ?? "en"
            if let matched = allLanguages.first(where: { $0.code == systemCode }) {
                applyLanguage(matched)
            } else {
                applyLanguage(defaultLanguage)
            }
        }
    }
    
    public func localizedString(_ key: String) -> String {
        return bundle.localizedString(forKey: key, value: "", table: nil)
    }
    
    public func localizedString(_ key: String, _ table: String) -> String {
        return bundle.localizedString(forKey: key, value: "", table: table)
    }
    
    public func setLanguage(_ language: LanguageModel?) {
        self.lang = language
        applyLanguage(language)
        UserDefaults.standard.set(language?.code, forKey: Keys.selectedLanguageCode)
        UserDefaults.standard.synchronize()
    }
    
    public func currentLanguage() -> LanguageModel? {
        return lang
    }
    
    private func applyLanguage(_ language: LanguageModel?) {
        let path = Bundle.main.path(forResource: language?.code ?? defaultLanguage.code, ofType: "lproj")
        if let path, let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = Bundle.main
        }
    }
}

protocol Localizable {
    func localize() -> String
}

extension String: Localizable {
    func localize() -> String {
        return LocalizeHelper.shared.localizedString(self)
    }
}

struct LanguageModel {
    let name: String
    let code: String
    let display: String
    let flag: String
}

extension LocalizeHelper {
    static func generateLanguages() -> [LanguageModel] {
        let list: [LanguageModel] = [
            .init(name: "English",             code: "en",     display: "English",              flag: "ic_flag_en"),
            .init(name: "French",              code: "fr",     display: "Français",             flag: "ic_flag_france"),
            .init(name: "Marathi",             code: "hi",     display: "मराठी (India)",          flag: "ic_flag_india"),
            .init(name: "Spanish",             code: "es",     display: "Espanol",              flag: "ic_flag_spain"),
            .init(name: "Chinese",             code: "zh",     display: "Chinese",              flag: "ic_flag_china"),
            .init(name: "Portuguese",          code: "pt",     display: "Português (Portugal)", flag: "ic_flag_portugal"),
            .init(name: "Russian",             code: "ru",     display: "Русский",              flag: "ic_flag_russia"),
            .init(name: "Indonesian",          code: "in",     display: "Indonesian",           flag: "ic_flag_indonesia"),
            .init(name: "Filipino",            code: "en-PH",  display: "Philippines",          flag: "ic_flag_philippines"),
            .init(name: "Bengali",             code: "bn",     display: "বাংলা",                 flag: "ic_flag_bangladesh"),
            .init(name: "Portuguese (Brazil)", code: "pt-BR",  display: "Português (Brazil)",   flag: "ic_flag_brazil"),
            .init(name: "Afrikaans",           code: "af-ZA",  display: "Afrikaans",            flag: "ic_flag_south_africa"),
            .init(name: "German",              code: "de",     display: "Deutsch",              flag: "ic_flag_germany"),
            .init(name: "English (Canada)",    code: "en-CA",  display: "Canada",               flag: "ic_flag_canada"),
            .init(name: "English (UK)",        code: "en-GB",  display: "English",              flag: "ic_flag_uk"),
            .init(name: "Korean",              code: "ko",     display: "Korean",               flag: "ic_flag_south_korea"),
            .init(name: "Dutch",               code: "nl",     display: "Dutch",                flag: "ic_flag_netherlands"),
            .init(name: "Vietnamese",          code: "vi",     display: "Vietnamese",           flag: "ic_flag_vietnam"),
            .init(name: "Saudi Arabia",        code: "ar",     display: "عربي",                 flag: "ic_flag_ar"),
        ]
        
        let currentCode = Locale.current.language.languageCode?.identifier ?? "en"
        guard let index = list.firstIndex(where: { $0.code == currentCode }) else { return list }
        
        var sorted = list
        sorted.insert(sorted.remove(at: index), at: 0)
        return sorted
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var localizedText: String? {
        get { return text }
        set(key) {
            text = key?.localize()
        }
    }
}

extension UITextField: XIBLocalizable {
    @IBInspectable public var localizedText: String? {
        get { return text }
        set(key) {
            text = key?.localize()
        }
    }
    @IBInspectable public var localizedPlaceholder: String? {
        get { return placeholder }
        set(key) {
            placeholder = key?.localize()
        }
    }
}

extension UITextView: XIBLocalizable {
    @IBInspectable public var localizedText: String? {
        get { return text }
        set(key) {
            text = key?.localize()
        }
    }
}

extension UIButton: XIBLocalizable {
    public var localizedText: String? {
        get { return title(for: .normal) }
        set(key) {
            setTitle(key?.localize(), for: .normal)
        }
    }
    
    @IBInspectable public var normalLocalizedTitle: String? {
        get { return title(for: .normal) }
        set(key) {
            setTitle(key?.localize(), for: .normal)
        }
    }
    @IBInspectable public var highlightedLocalizedTitle: String? {
        get { return title(for: .highlighted) }
        set(key) {
            setTitle(key?.localize(), for: .highlighted)
        }
    }
    @IBInspectable public var selectedLocalizedTitle: String? {
        get { return title(for: .selected) }
        set(key) {
            setTitle(key?.localize(), for: .selected)
        }
    }
    @IBInspectable public var disabledLocalizedTitle: String? {
        get { return title(for: .disabled) }
        set(key) {
            setTitle(key?.localize(), for: .disabled)
        }
    }
}

@objc public protocol XIBLocalizable {
    var localizedText: String? { get set }
    @objc optional var localizedPlaceholder: String? { get set }
    @objc optional var normalLocalizedTitle: String? { get set }
    @objc optional var highlightedLocalizedTitle: String? { get set }
    @objc optional var selectedLocalizedTitle: String? { get set }
    @objc optional var disabledLocalizedTitle: String? { get set }
}
