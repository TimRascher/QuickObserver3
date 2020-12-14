import XCTest
@testable import QuickObserver3

final class QuickObserver3Tests: XCTestCase {
    let observedObject = ObservedObject()
    func testForRacingConditions() {
        let expectation = XCTestExpectation(description: "Operation Completes without any errors")
        observedObject.done = { expectation.fulfill() }
        observedObject.run()
        wait(for: [expectation], timeout: 20)
    }

    static var allTests = [
        ("testForRacingConditions", testForRacingConditions),
    ]
}
class ObservedObject: QuickObserverObservable {
    let range = 0..<1000000
    var observer = QuickObserver<Actions, Error>()
    var setAndRemoveQueue = DispatchQueue(label: "SetAndRemove", qos: .userInteractive)
    var updateQueue = DispatchQueue(label: "Update", qos:.background)
    var objects = [ObserverObject]()
    var jobDone = 0
    var done: (() -> ())?
    func run() {
        func done() {
            jobDone += 1
            if jobDone == 2 {
                self.done?()
            }
        }
        setAndRemoveQueue.async { // Run a million objects, while randomly removing old objects half the time.
            for _ in self.range {
                self.objects.append(ObserverObject().watch(self))
                if Bool.random() {
                    let index = Int.random(in: 0..<self.objects.count)
                    self.objects.remove(at: index)
                }
            }
            done()
        }
        updateQueue.async { // Update all objects with a possitive result.
            for _ in self.range {
                self.observer.report(.reported)
            }
            done()
        }
    }
}
extension ObservedObject {
    enum Actions {
        case reported
    }
}
class ObserverObject {
    func watch(_ object: ObservedObject) -> ObserverObject {
        object.add(self) { (this, result) in
            print(result)
        }
        return self
    }
}
