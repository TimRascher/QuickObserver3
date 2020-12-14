// Created by Timothy Rascher
//  

import Foundation

public protocol QuickObserverObservable {
    associatedtype Actions
    associatedtype Errors: Error
    var observer: QuickObserver<Actions, Errors> { get }
    func add<Observer: AnyObject>(_ observer: Observer, handler: @escaping QuickObserverHandler<Observer, Actions, Errors>)
    func afterObserverAdded<Observer: AnyObject>(_ observer: Observer)
}
public extension QuickObserverObservable {
    func add<Observer: AnyObject>(_ observer: Observer, handler: @escaping QuickObserverHandler<Observer, Actions, Errors>) {
        self.observer.add(observer, handler: handler)
        afterObserverAdded(observer)
    }
    func afterObserverAdded<Observer: AnyObject>(_ observer: Observer) { }
}

public protocol QuickObservable {
    associatedtype Actions
    associatedtype Errors: Error
    var observer: QuickObserver<Actions, Errors> { get }
    func add(handler: @escaping QuickHandler<Actions, Errors>)
    func afterAdded()
}
public extension QuickObservable {
    func add(handler: @escaping QuickHandler<Actions, Errors>) {
        observer.add(handler: handler)
        afterAdded(observer)
    }
    func afterAdded<Observer: AnyObject>(_ observer: Observer) { }
}
