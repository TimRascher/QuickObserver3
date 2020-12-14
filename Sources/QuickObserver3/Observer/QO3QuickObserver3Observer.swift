// Created by Timothy Rascher
//  

import Foundation

public typealias QuickHandler<Actions, Errors: Error> = (Result<Actions, Errors>) -> ()
public typealias QuickObserverHandler<Observer: AnyObject, Actions, Errors: Error> = (Observer, Result<Actions, Errors>) -> ()

public protocol QuickObserver3Observer {
    associatedtype Actions
    associatedtype Errors: Error
    var observers: [UUID: QuickHandler<Actions, Errors>] { get }
    var processorQueue: DispatchQueue { get }
    func add(handler: @escaping QuickHandler<Actions, Errors>)
    func add<Observer: AnyObject>(_ object: Observer, handler: @escaping QuickObserverHandler<Observer, Actions, Errors>)
    func report(_ action: Actions)
    func report(_ errors: Errors)
}
