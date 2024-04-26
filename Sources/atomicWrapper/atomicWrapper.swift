import Foundation

@propertyWrapper
public final class Atomic<T>: @unchecked Sendable {
    
    @usableFromInline
    let locker: NSLock = NSLock()

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
        set {
            locker.lock()
            defer {
                locker.unlock()
            }
            storedValue = newValue
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
