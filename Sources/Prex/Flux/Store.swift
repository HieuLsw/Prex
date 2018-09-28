//
//  Store.swift
//  Prex
//
//  Created by marty-suzuki on 2018/09/29.
//  Copyright © 2018 marty-suzuki. All rights reserved.
//

import Foundation

open class Store<Mutation: Prex.Mutation> {
    public typealias Action = Mutation.Action
    public typealias State = Mutation.State

    private var _state: State {
        didSet {
            changed?(ChangedValue(new: _state, old: oldValue))
        }
    }

    internal private(set) var state: State {
        set {
            defer { lock.unlock() }; lock.lock()
            _state = newValue
        }
        get {
            defer { lock.unlock() }; lock.lock()
            return _state
        }
    }

    internal var changed: ((ChangedValue<State>) -> ())?

    private let lock: NSLocking = NSRecursiveLock()

    public init(dispatcher: Dispatcher<Action>, state: State, mutation: Mutation) {
        self._state = state

        dispatcher.handler = { [mutation, weak self] action in
            guard let self = self else {
                return
            }
            mutation.mutate(action: action, state: &self.state)
        }
    }
}

public struct ChangedValue<T> {
    public let new: T
    public let old: T?
}
