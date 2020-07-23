//
//  Collection+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 09.12.19.
//  Copyright © 2017 Lautsprecher Teufel GmbH. All rights reserved.
//

extension Collection {
    /// Given a predicate to select the elements you want to modify in this Collection, and a key-path to a single property
    /// in these elements, update all the matching items' property to a constant value.
    ///
    /// For example:
    /// ```
    /// struct User {
    ///    var name: String
    ///    var city: String
    /// }
    ///
    /// var users: [User] = getUsersFromPotsdam()
    /// users.updateElement(where: { $0.name == "Blob" }, keyPath: \.city, value: "Berlin")
    /// ```
    ///
    /// In this example, given an array of multiple users from Potsdam, we will mutate all users with name "Blob", moving
    /// them to "Berlin". The other users will remain unchanged.
    ///
    /// - Parameters:
    ///   - predicate: A selector for the elements you want to modify. The other elements will remain unchanged.
    ///   - keyPath: A key-path to the property you want to change
    ///   - value: The new value you want to set for the property you choose, for all the matching elements in this collection
    /// - Returns: An array of elements having the requested changes, if any.
    public func updateElement<A>(where predicate: (Element) -> Bool, keyPath: WritableKeyPath<Element, A>, value: A) -> [Element] {
        return updateElement(where: predicate) { item in
            item[keyPath: keyPath] = value
        }
    }

    /// Given a predicate to select the elements you want to modify in this Collection, and a transform closure that will
    /// give you the `inout` element that matches that predicate, update all the matching items.
    ///
    /// For example:
    /// ```
    /// struct User {
    ///    var name: String
    ///    var city: String
    /// }
    ///
    /// var users: [User] = getUsersFromPotsdam()
    /// users.updateElement(where: { $0.name == "Blob" }) { element in
    ///    element.city = "Berlin"
    /// }
    /// ```
    ///
    /// In this example, given an array of multiple users from Potsdam, we will mutate all users with name "Blob", moving
    /// them to "Berlin". The other users will remain unchanged.
    ///
    /// - Parameters:
    ///   - predicate: A selector for the elements you want to modify. The other elements will remain unchanged.
    ///   - transform: A function that will provide with an `inout` Element, that means you can read and write into it,
    ///                for all the matching elements in this collection
    /// - Returns: An array of elements having the requested changes, if any.
    public func updateElement(where predicate: (Element) -> Bool, _ transform: (inout Element) -> Void) -> [Element] {
        return map { item in
            guard predicate(item) else { return item }
            var mutableItem = item
            transform(&mutableItem)
            return mutableItem
        }
    }
}

extension Collection {
    /// Safely get the item at the given index. If the index is out-of-bounds, it will return nil
    ///
    /// - Parameter index: element index
    /// - Returns: element at the given index or nil if wrong index was provided.
    public subscript(safe index: Index) -> Element? {
        get {
            return inBounds(index) ? self[index] : nil
        }
    }

    fileprivate func inBounds(_ index: Index) -> Bool {
        return index < endIndex && index >= startIndex
    }
}

extension MutableCollection {
    /// Safely get or set the item at the given index. If the index is out-of-bounds, it will return nil
    ///
    /// - Parameter index: element index
    /// - Returns: element at the given index or nil if wrong index was provided.
    public subscript(safe index: Index) -> Element? {
        get {
            return inBounds(index) ? self[index] : nil
        }
        set {
            guard inBounds(index), let newValue = newValue else { return }
            self[index] = newValue
        }
    }
}

extension RangeReplaceableCollection {

    /// Safely remove the item at the given index and return it.
    /// If the index is out-of-bounds, array won't be modified and the return will be nil.
    ///
    /// - Parameter index: element index
    /// - Returns: element removed or nil if wrong index was provided.
    @discardableResult
    public mutating func removeSafe(at index: Index) -> Element? {
        guard let item = self[safe: index] else { return nil }
        remove(at: index)
        return item
    }
}
