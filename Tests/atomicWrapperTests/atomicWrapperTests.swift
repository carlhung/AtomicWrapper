import XCTest
@testable import AtomicWrapper

final class atomicWrapperTests: XCTestCase, @unchecked Sendable {

    let iterations = 100_000_000

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
}
