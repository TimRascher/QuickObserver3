// Created by Timothy Rascher
//  

import Foundation

public typealias QuickActionHandler<Actions> = (Result<Actions, Error>) -> ()
public typealias QuickActionObserverHandler<Observer: AnyObject, Actions> = (Observer, Result<Actions, Error>) -> ()

public typealias QuickAction<Actions> = QuickObserver<Actions, Error>
