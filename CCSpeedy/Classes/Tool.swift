
import Foundation

public func lz(_ text: String) -> String {
    return NSLocalizedString(text, tableName: "Localizations", bundle: Bundle.main, value: "", comment: "")
}

public class Tool {
    
    static var appIcon: UIImage? {
        if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    @available(iOSApplicationExtension, unavailable)
    public static func topViewController() -> UIViewController {
        return topViewControllerOptional()!
    }
    
    @available(iOSApplicationExtension, unavailable)
    public static func topViewControllerOptional() -> UIViewController? {
        var keyWinwow = UIApplication.shared.keyWindow
        if keyWinwow == nil {
            keyWinwow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        }
        if #available(iOS 13.0, *), keyWinwow == nil {
            keyWinwow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        }
        
        var top = keyWinwow?.rootViewController
        if top == nil {
            top = UIApplication.shared.delegate?.window??.rootViewController
        }
        
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        
        return top
    }
    
}

extension Tool {

    public static func appName() -> String {
        if let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        } else if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        } else {
            return Bundle.main.infoDictionary?["CFBundleName"] as! String
        }
    }
    
    public static func appVersion() -> String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    public static func buildNumber() -> String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
}

extension Tool {
    
    public static let isIPad: Bool = {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }()
    
    @available(iOSApplicationExtension, unavailable)
    public static var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    @available(iOSApplicationExtension, unavailable)
    public static let deviceWidth = isLandscape ? UIScreen.main.bounds.height : UIScreen.main.bounds.width

    @available(iOSApplicationExtension, unavailable)
    public static let deviceHeight = isLandscape ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
    
}

extension Tool {
    
    static func isChina() -> Bool {
        if getLanguageType() == "zh-Hans-CN" {
            return true
        } else {
            return false
        }
    }
    
    static func getLanguageType() -> String {
        let def = UserDefaults.standard
        let allLanguages: [String] = def.object(forKey: "AppleLanguages") as! [String]
        let chooseLanguage = allLanguages.first
        return chooseLanguage ?? "en"
    }
    
    public static func countryCode() -> String {
        return NSLocale.current.regionCode ?? ""
    }
    
    public static func languageCode() -> String {
        let languageCode = NSLocale.preferredLanguages.first ?? ""
        
        if languageCode.starts(with: "zh-HK") {
            return "zh-Hant"
        }
        
        var components = languageCode.split(separator: "-")
        if components.count >= 2, let suffix = components.last, suffix == suffix.uppercased() { // 如 pt-PT、pt-BR 则输出 pt
            components.removeLast()
            return components.joined(separator: "-")
        }
        
        return languageCode
    }
}

extension Tool {
    
   static func rateApp(appID: String) {
        if let url = URL(string: "https://itunes.apple.com/us/app/id\(appID)?action=write-review") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
