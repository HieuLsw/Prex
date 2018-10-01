//
//  Flux.swift
//  Prex
//
//  Created by marty-suzuki on 2018/10/02.
//  Copyright © 2018 marty-suzuki. All rights reserved.
//

public class Flux<Action: Prex.Action, State: Prex.State> {
    
    public let dispatcher = Dispatcher<Action>()
    public let store: Store<State>

    public init<Mutation: Prex.Mutation>(state: State, mutation: Mutation) where Action == Mutation.Action, State == Mutation.State {
        self.store = Store(dispatcher: dispatcher, state: state, mutation: mutation)
    }
}

