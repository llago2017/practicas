public struct ArrayStack<Element>: Stack {
    private var storage = [Element]()

    public init() {
    }
    
    public mutating func push(_ value: Element) {
        storage.insert(value, at: 0)
    }
    
    public mutating func pop() -> Element? {
        guard storage.count > 0 else { return nil }
        return storage.remove(at: 0)
    }

    public func forEach(_ body: (Element) throws -> Void) rethrows {

        for client in storage {
            try! body(client)
        }
    }
}