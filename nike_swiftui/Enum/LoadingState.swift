//
//  LoadingState.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

enum LoadingState<T> {
    case idle
    case loading
    case finished(T)
    case error(Error)
}
