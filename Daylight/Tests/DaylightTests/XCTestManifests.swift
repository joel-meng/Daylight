#if !canImport(ObjectiveC)
import XCTest

extension CancellableFutureTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CancellableFutureTests = [
        ("testCancellableFutureCancelledAfterObserverSet", testCancellableFutureCancelledAfterObserverSet),
        ("testCancellableFutureCancelledAfterObserverSetWithOnlySuccessListening", testCancellableFutureCancelledAfterObserverSetWithOnlySuccessListening),
        ("testCancellableFutureCancelledBeforeAndAfter", testCancellableFutureCancelledBeforeAndAfter),
        ("testCancellableFutureCancelledBeforeAndAfterWithOnlySuccessListener", testCancellableFutureCancelledBeforeAndAfterWithOnlySuccessListener),
        ("testCancellableFutureCancelledBeforeObserverSet", testCancellableFutureCancelledBeforeObserverSet),
        ("testCancellableFutureCancelledBeforeObserverSetWithOnlySuccessListening", testCancellableFutureCancelledBeforeObserverSetWithOnlySuccessListening),
        ("testCancellableFutureCancelledMultipleTimesAfterObserverSet", testCancellableFutureCancelledMultipleTimesAfterObserverSet),
        ("testCancellableFutureCancelledMultipleTimesBeforeObserverSet", testCancellableFutureCancelledMultipleTimesBeforeObserverSet),
        ("testCancellableFutureCreationInitialState", testCancellableFutureCreationInitialState),
        ("testCancelState", testCancelState),
    ]
}

extension FutureTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FutureTests = [
        ("testFutureRejectedWithError", testFutureRejectedWithError),
        ("testFutureResolvedMappingWithDifferentTypeValue", testFutureResolvedMappingWithDifferentTypeValue),
        ("testFutureResolvedMappingWithError", testFutureResolvedMappingWithError),
        ("testFutureResolvedMappingWithValue", testFutureResolvedMappingWithValue),
        ("testFutureResolvedWithValue", testFutureResolvedWithValue),
        ("testFutureWithInitialError", testFutureWithInitialError),
        ("testFutureWithInitialValue", testFutureWithInitialValue),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CancellableFutureTests.__allTests__CancellableFutureTests),
        testCase(FutureTests.__allTests__FutureTests),
    ]
}
#endif
