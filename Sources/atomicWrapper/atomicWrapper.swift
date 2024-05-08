import Foundation

@propertyWrapper
public final class Atomic<T>: @unchecked Sendable {
    
    // lock() and unlock() should be called on the same thread. 
    // Therefore, between calling lock() and unlock(), It shouldn't have async/await calls. 
    // Because it doesn't guarantee after the suspension, It will run on the same thread. 
    @usableFromInline
    let locker = NSLock()

    @usableFromInline
    var storedValue: T

    @inlinable
    public init(wrappedValue: T) {
        self.storedValue = wrappedValue
    }

    @inlinable
    public init(_ wrappedValue: T) {
        self.storedValue = wrappedValue
    }

    @inlinable
    public var wrappedValue: T {
        _read {
            locker.lock()
            defer {
                locker.unlock()
            }
            yield storedValue
        }
        _modify {
            locker.lock()
            defer {
                locker.unlock()
            }
            yield &storedValue
        }
    }

    @discardableResult
    @inlinable
    public func safe<R>(_ execute: (inout T) throws -> R) rethrows -> R {
        locker.lock()
        defer {
            locker.unlock()
        }
        return try execute(&storedValue)
    }
}
