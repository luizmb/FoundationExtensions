//
//  Function+Zip.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 09.12.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

// swiftlint:disable line_length

// Singleton Zip
public func zip<A, B>(_ a: @escaping () -> A, _ b: @escaping () -> B) -> () -> (A, B) {
    return { (a(), b()) }
}

public func zip<A, B, C>(_ a: @escaping () -> A, _ b: @escaping () -> B, _ c: @escaping () -> C) -> () -> (A, B, C) {
    return { (a(), b(), c()) }
}

public func zip<A, B, C, D>(_ a: @escaping () -> A, _ b: @escaping () -> B, _ c: @escaping () -> C, _ d: @escaping () -> D) -> () -> (A, B, C, D) {
    return { (a(), b(), c(), d()) }
}

public func zip<A, B, C, D, E>(_ a: @escaping () -> A, _ b: @escaping () -> B, _ c: @escaping () -> C, _ d: @escaping () -> D, _ e: @escaping () -> E) -> () -> (A, B, C, D, E) {
    return { (a(), b(), c(), d(), e()) }
}

public func zip<A, B, C, D, E, F>(_ a: @escaping () -> A, _ b: @escaping () -> B, _ c: @escaping () -> C, _ d: @escaping () -> D, _ e: @escaping () -> E, _ f: @escaping () -> F) -> () -> (A, B, C, D, E, F) {
    return { (a(), b(), c(), d(), e(), f()) }
}

// Singleton Tuple Zip
public func zip<A, B>(_ tuple: (() -> A, () -> B)) -> () -> (A, B) {
    return { (tuple.0(), tuple.1()) }
}

public func zip<A, B, C>(_ tuple: (() -> A, () -> B, () -> C)) -> () -> (A, B, C) {
    return { (tuple.0(), tuple.1(), tuple.2()) }
}

public func zip<A, B, C, D>(_ tuple: (() -> A, () -> B, () -> C, () -> D)) -> () -> (A, B, C, D) {
    return { (tuple.0(), tuple.1(), tuple.2(), tuple.3()) }
}

public func zip<A, B, C, D, E>(_ tuple: (() -> A, () -> B, () -> C, () -> D, () -> E)) -> () -> (A, B, C, D, E) {
    return { (tuple.0(), tuple.1(), tuple.2(), tuple.3(), tuple.4()) }
}

public func zip<A, B, C, D, E, F>(_ tuple: (() -> A, () -> B, () -> C, () -> D, () -> E, () -> F)) -> () -> (A, B, C, D, E, F) {
    return { (tuple.0(), tuple.1(), tuple.2(), tuple.3(), tuple.4(), tuple.5()) }
}

// Product fold
public func zip<A, B, Z>(_ a: @escaping (Z) -> A, _ b: @escaping (Z) -> B) -> (Z) -> (A, B) {
    return { (a($0), b($0)) }
}

public func zip<A, B, C, Z>(_ a: @escaping (Z) -> A, _ b: @escaping (Z) -> B, _ c: @escaping (Z) -> C) -> (Z) -> (A, B, C) {
    return { (a($0), b($0), c($0)) }
}

public func zip<A, B, C, D, Z>(_ a: @escaping (Z) -> A, _ b: @escaping (Z) -> B, _ c: @escaping (Z) -> C, _ d: @escaping (Z) -> D) -> (Z) -> (A, B, C, D) {
    return { (a($0), b($0), c($0), d($0)) }
}

public func zip<A, B, C, D, E, Z>(_ a: @escaping (Z) -> A, _ b: @escaping (Z) -> B, _ c: @escaping (Z) -> C, _ d: @escaping (Z) -> D, _ e: @escaping (Z) -> E) -> (Z) -> (A, B, C, D, E) {
    return { (a($0), b($0), c($0), d($0), e($0)) }
}

public func zip<A, B, C, D, E, F, Z>(_ a: @escaping (Z) -> A, _ b: @escaping (Z) -> B, _ c: @escaping (Z) -> C, _ d: @escaping (Z) -> D, _ e: @escaping (Z) -> E, _ f: @escaping (Z) -> F) -> (Z) -> (A, B, C, D, E, F) {
    return { (a($0), b($0), c($0), d($0), e($0), f($0)) }
}
// swiftlint:enable line_length
