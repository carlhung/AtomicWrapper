import XCTest
@testable import AtomicWrapper


struct SomeThing {
    @Atomic 
    var arr = [Int]()

    func run() {
        arr.append(0)
    }
}

final class AtomicWrapperTests: XCTestCase, @unchecked Sendable {

    let iterations = 100_000_000

    var something = SomeThing()

    @Atomic
    var arr = [Int]()

    func testAsPropertyWrapper() async {
        await performAsync(iterations: iterations) {
            self.arr.append(0)
        }

        XCTAssertEqual(arr.count, iterations)
    }

    func testAsWrapper() async {
        let arr = Atomic([Int]())
        await performAsync(iterations: iterations) {
            arr.safe {
                $0.append(0)
            }
        }

        XCTAssertEqual(arr.safe(\.count), iterations)
    }

    func testStruct() async {
        await performAsync(iterations: iterations) {
            self.something.run()
        }
        XCTAssertEqual(something.arr.count, iterations)
    }
}

private func performAsync(iterations: Int, execute: @Sendable @escaping () -> Void) async {
    await withCheckedContinuation { continuation in
        DispatchQueue.global().async {   
            DispatchQueue.concurrentPerform(iterations: iterations) { _ in
                execute()
            }
            continuation.resume(returning: ())
        }
    }
}

@globalActor
final actor MyActor {
    static let shared: MyActor = MyActor()
}

// @MyActor
struct ST {
    @Atomic
    var val = 0

    @MainActor
    func foo() async {
        _val.safe {
            $0 = 10
        }
    }
}