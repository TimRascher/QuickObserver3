// Created by Timothy Rascher
//  

import Foundation

public class QuickObserver<Actions, Errors: Error> {
    public private(set) var observers = [UUID : QuickHandler<Actions, Errors>]()
    public let processorQueue: DispatchQueue
    public let options: Options
    
    public init(options: Options = Options.defaultOptions) {
        self.processorQueue = DispatchQueue(label: options.queueName, qos: options.dispatchQoS)
        self.options = options
    }
    public static func mainThreadReporter() -> QuickObserver {
        let options = Options(shouldReportOnMainThread: true)
        return .init(options: options)
    }
}
public extension QuickObserver {
    struct Options {
        public var queueName: String
        public var shouldReportOnMainThread: Bool
        public var dispatchQoS: DispatchQoS
        public init(
            queueName: String = "QuickObserverQueue.\(UUID().uuidString)",
            shouldReportOnMainThread: Bool = false,
            dispatchQoS: DispatchQoS = .userInteractive) {

            self.queueName = queueName
            self.shouldReportOnMainThread = shouldReportOnMainThread
            self.dispatchQoS = dispatchQoS
        }
        public static var defaultOptions: Options { Options() }
    }
}
extension QuickObserver: QuickObserver3Observer {
    public func add(handler: @escaping QuickHandler<Actions, Errors>) {
        processorQueue.async { [weak self] in
            guard let self = self else { return }
            let identifier = UUID()
            self.observers[identifier] = { [weak self] (result) in
                guard let self = self else { return }
                self.processorQueue.async { [weak self] in
                    guard let self = self else { return }
                    if self.observers.keys.contains(identifier) {
                        self.observers.removeValue(forKey: identifier)
                    }
                }
                if self.options.shouldReportOnMainThread {
                    DispatchQueue.main.async {
                        handler(result)
                    }
                    return
                }
                handler(result)
            }
        }
    }
    public func add<Observer>(_ observer: Observer, handler: @escaping QuickObserverHandler<Observer, Actions, Errors>) where Observer : AnyObject {
        processorQueue.async { [weak self] in
            guard let self = self else { return }
            let identifier = UUID()
            self.observers[identifier] = { [weak observer, weak self] (result) in
                guard let self = self else { return }
                guard let observer = observer else {
                    self.processorQueue.async { [weak self] in
                        guard let self = self else { return }
                        if self.observers.keys.contains(identifier) {
                            self.observers.removeValue(forKey: identifier)
                        }
                    }
                    return
                }
                if self.options.shouldReportOnMainThread {
                    DispatchQueue.main.async {
                        handler(observer, result)
                    }
                    return
                }
                handler(observer, result)
            }
        }
    }
    public func report(_ action: Actions) {
        processorQueue.async { [weak self] in
            guard let self = self else { return }
            let result: Result<Actions, Errors> = Result.success(action)
            for identifier in self.observers.keys {
                self.observers[identifier]?(result)
            }
        }
    }
    public func report(_ errors: Errors) {
        processorQueue.async { [weak self] in
            guard let self = self else { return }
            let result: Result<Actions, Errors> = Result.failure(errors)
            for identifier in self.observers.keys {
                self.observers[identifier]?(result)
            }
        }
    }
}
