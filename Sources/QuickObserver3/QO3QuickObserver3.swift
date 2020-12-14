// Created by Timothy Rascher
//

import Foundation

public struct QuickObserver3Package {
    private init() {}
}
public extension QuickObserver3Package {
    static var bundle: Bundle {
        class Helper {}
        return Bundle(for: Helper.self)
    }
}
