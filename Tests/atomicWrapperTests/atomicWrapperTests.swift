import XCTest
@testable import atomicWrapper

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

    func foo() {
        let atomicValue = Atomic(0)
        
        // write a new value.
        atomicValue.safe {
            $0 = 10
        }

        // read value.
        let f: (inout Int) -> Int = \.self
        let val1: Int = atomicValue.safe(f)
        let val2: Int = atomicValue.safe { $0 }
        let valInString = atomicValue.safe { (val: inout Int) in
            val.description
        }
    }
}
