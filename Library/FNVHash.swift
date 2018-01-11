// import Foundation

struct FNVHash {
    // FNV parameters
    static let offsetBasis: UInt32 = 2166136261
    static let prime: UInt32 = 16777619

    /// Calculates FNV-1a hash from a raw byte sequence, such as an array.
    static func fnv1a_32<S: Sequence>(bytes: S) -> UInt32 where S.Iterator.Element == UInt8 {
        var hash = FNVHash.offsetBasis
        for byte in bytes {
            hash ^= UInt32(byte)
            hash = hash &* FNVHash.prime
        }
        return hash
    }

    /// Calculates FNV-1a hash from a String using it's UTF8 representation.
    static func fnv1a_32(string str: String) -> UInt32 {
        return FNVHash.fnv1a_32(bytes: str.utf8)
    }
}
