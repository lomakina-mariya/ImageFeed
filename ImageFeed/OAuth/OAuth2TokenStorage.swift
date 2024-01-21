
import Foundation

final class OAuth2TokenStorage {
    private let key = "token"
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
