//
//  Transient.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 12.07.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

/// Wraps a value but causes it to be treated as "value-less" for the purposes
/// of automatic Equatable, Hashable, and Codable synthesis. This allows one to
/// declare a "cache"-like property in a value type without giving up the rest
/// of the benefits of synthesis.
@propertyWrapper
public struct Transient<Wrapped> {
    public var wrappedValue: Wrapped

    public init(_ wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }
}

extension Transient where Wrapped: Equatable {
    public static func == (lhs: Transient<Wrapped>, rhs: Transient<Wrapped>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Transient {
    public func map<WrappedB>(_ f: (Wrapped) -> WrappedB) -> Transient<WrappedB> {
        return .init(f(self.wrappedValue))
    }

    public func flatMap<WrappedB>(_ f: (Wrapped) -> Transient<WrappedB>) -> Transient<WrappedB> {
        return f(self.wrappedValue)
    }
}

extension Transient: Equatable {
    public static func == (lhs: Transient<Wrapped>, rhs: Transient<Wrapped>) -> Bool {
        // By always returning true, transient values never produce false negatives
        // that cause two otherwise equal values to become unequal. In other words,
        // they are ignored for the purposes of equality.
        return true
    }
}

extension Transient where Wrapped: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Transient: Encodable {
    public func encode(to encoder: Encoder) throws {
        // Transient properties do not get encoded.
    }
}

extension Transient: Comparable where Wrapped: Comparable {
    public static func < (lhs: Transient, rhs: Transient) -> Bool {
        return lhs.wrappedValue < rhs.wrappedValue
    }
}

extension Transient: Decodable where Wrapped: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            self.init(try decoder.singleValueContainer().decode(Wrapped.self))
        } catch {
            self.init(try .init(from: decoder))
        }
    }
}

extension Transient where Wrapped: Hashable {
    public func hash(into hasher: inout Hasher) {
        wrappedValue.hash(into: &hasher)
    }
}

extension Transient: Hashable {
    public func hash(into hasher: inout Hasher) {
        // Transient values do not contribute to the hash value.
    }
}

extension Transient: CustomStringConvertible {
    public var description: String {
        return String(describing: self.wrappedValue)
    }
}

extension Transient: RawRepresentable {
    public typealias RawValue = Wrapped

    public init(rawValue: Wrapped) {
        self.init(rawValue)
    }

    public var rawValue: Wrapped {
        wrappedValue
    }
}

extension Transient: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return self.wrappedValue
    }
}

extension Transient: Collection where Wrapped: Collection {
    public typealias Element = Wrapped.Element
    public typealias Index = Wrapped.Index

    public func index(after i: Wrapped.Index) -> Wrapped.Index {
        return wrappedValue.index(after: i)
    }

    public subscript(position: Wrapped.Index) -> Wrapped.Element {
        return wrappedValue[position]
    }

    public var startIndex: Wrapped.Index {
        return wrappedValue.startIndex
    }

    public var endIndex: Wrapped.Index {
        return wrappedValue.endIndex
    }

    public __consuming func makeIterator() -> Wrapped.Iterator {
        return wrappedValue.makeIterator()
    }
}

extension Transient: Error where Wrapped: Error {}

extension Transient: LocalizedError where Wrapped: Error {
    public var errorDescription: String? {
        return wrappedValue.localizedDescription
    }
    public var failureReason: String? {
        return (wrappedValue as? LocalizedError)?.failureReason
    }
    public var helpAnchor: String? {
        return (wrappedValue as? LocalizedError)?.helpAnchor
    }
    public var recoverySuggestion: String? {
        return (wrappedValue as? LocalizedError)?.recoverySuggestion
    }
}

extension Transient: ExpressibleByBooleanLiteral where Wrapped: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Wrapped.BooleanLiteralType

    public init(booleanLiteral value: Wrapped.BooleanLiteralType) {
        self.init(Wrapped(booleanLiteral: value))
    }
}

extension Transient: ExpressibleByExtendedGraphemeClusterLiteral where Wrapped: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = Wrapped.ExtendedGraphemeClusterLiteralType

    public init(extendedGraphemeClusterLiteral: ExtendedGraphemeClusterLiteralType) {
        self.init(Wrapped(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
    }
}

extension Transient: ExpressibleByFloatLiteral where Wrapped: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Wrapped.FloatLiteralType

    public init(floatLiteral: FloatLiteralType) {
        self.init(Wrapped(floatLiteral: floatLiteral))
    }
}

extension Transient: ExpressibleByIntegerLiteral where Wrapped: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Wrapped.IntegerLiteralType

    public init(integerLiteral: IntegerLiteralType) {
        self.init(Wrapped(integerLiteral: integerLiteral))
    }
}

extension Transient: ExpressibleByStringLiteral where Wrapped: ExpressibleByStringLiteral {
    public typealias StringLiteralType = Wrapped.StringLiteralType

    public init(stringLiteral: StringLiteralType) {
        self.init(Wrapped(stringLiteral: stringLiteral))
    }
}

extension Transient: ExpressibleByStringInterpolation where Wrapped: ExpressibleByStringInterpolation {
    public typealias StringInterpolation = Wrapped.StringInterpolation

    public init(stringInterpolation: Self.StringInterpolation) {
        self.init(Wrapped(stringInterpolation: stringInterpolation))
    }
}

extension Transient: ExpressibleByUnicodeScalarLiteral where Wrapped: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = Wrapped.UnicodeScalarLiteralType

    public init(unicodeScalarLiteral: UnicodeScalarLiteralType) {
        self.init(Wrapped(unicodeScalarLiteral: unicodeScalarLiteral))
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Transient: Identifiable where Wrapped: Identifiable {
    public typealias ID = Wrapped.ID

    public var id: ID {
        return wrappedValue.id
    }
}

extension Transient: LosslessStringConvertible where Wrapped: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let wrappedValue = Wrapped(description) else { return nil }
        self.init(wrappedValue)
    }
}

extension Transient: AdditiveArithmetic where Wrapped: AdditiveArithmetic {
    public static var zero: Transient {
        return self.init(.zero)
    }

    public static func + (lhs: Transient, rhs: Transient) -> Transient {
        return self.init(lhs.wrappedValue + rhs.wrappedValue)
    }

    public static func += (lhs: inout Transient, rhs: Transient) {
        lhs.wrappedValue += rhs.wrappedValue
    }

    public static func - (lhs: Transient, rhs: Transient) -> Transient {
        return self.init(lhs.wrappedValue - rhs.wrappedValue)
    }

    public static func -= (lhs: inout Transient, rhs: Transient) {
        lhs.wrappedValue -= rhs.wrappedValue
    }
}

extension Transient: Numeric where Wrapped: Numeric {
    public init?<T>(exactly source: T) where T: BinaryInteger {
        guard let wrappedValue = Wrapped(exactly: source) else { return nil }
        self.init(wrappedValue)
    }

    public var magnitude: Wrapped.Magnitude {
        return self.wrappedValue.magnitude
    }

    public static func * (lhs: Transient, rhs: Transient) -> Transient {
        return self.init(lhs.wrappedValue * rhs.wrappedValue)
    }

    public static func *= (lhs: inout Transient, rhs: Transient) {
        lhs.wrappedValue *= rhs.wrappedValue
    }
}

extension Transient: SignedNumeric where Wrapped: SignedNumeric {}

extension Transient: Sequence where Wrapped: Sequence {
    public typealias Iterator = Wrapped.Iterator

    public __consuming func makeIterator() -> Wrapped.Iterator {
        return wrappedValue.makeIterator()
    }
}
