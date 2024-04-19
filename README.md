# AtomicWrapper

Add the line below in `Package.swift`:
```swift
.package(url: "https://github.com/carlhung/AtomicWrapper.git", branch: "main")
```

Also add below in `Package.swift`:
```swift
dependencies: ["atomicWrapper"]
```

import:
```swift
import atomicWrapper
```

It can be used it as a property wrapper. But Don't this property wrapper on properties in a function. It may cause issue. Instead, Use this property wrapper on properties in types.
```swift
struct A_type {
    @Atomic
    var val = 0
}
```

Or:
It can be used as a wrapper
```swift
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
```