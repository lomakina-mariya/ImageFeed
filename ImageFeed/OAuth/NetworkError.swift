
import Foundation

enum NetworkError: Error {
    case badURL
    case httpStatusCode(Int)
    case invalidDecoding
}
