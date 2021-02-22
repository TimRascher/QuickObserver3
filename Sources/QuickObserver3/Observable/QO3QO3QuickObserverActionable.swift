// Created by Timothy Rascher
//  

import Foundation

public protocol QuickObserverActionable {
    associatedtype Actions
    var observer: QuickAction<Actions> { get }
    func add<Observer: AnyObject>(_ observer: Observer, handler: @escaping QuickActionObserverHandler<Observer, Actions>)
    func afterObserverAdded<Observer: AnyObject>(_ observer: Observer)
}
public extension QuickObserverActionable {
    func add<Observer: AnyObject>(_ observer: Observer, handler: @escaping QuickActionObserverHandler<Observer, Actions>) {
        self.observer.add(observer, handler: handler)
        afterObserverAdded(observer)
    }
    func afterObserverAdded<Observer: AnyObject>(_ observer: Observer) { }
}

public protocol QuickActionable {
    associatedtype Actions
    var observer: QuickAction<Actions> { get }
    func add(handler: @escaping QuickActionHandler<Actions>)
    func afterAdded()
}
public extension QuickActionable {
    func add(handler: @escaping QuickActionHandler<Actions>) {
        observer.add(handler: handler)
        afterAdded()
    }
    func afterAdded() { }
}
