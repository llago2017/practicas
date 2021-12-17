import Socket

public struct ArrayQueue<T>: Queue {
    private var storage = [T]()

    public var count: Int = 0
    public var maxCapacity: Int = 3

    public init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
    }
    
    public mutating func enqueue(_ value: T) throws{
        storage.append(value)
    }

    public mutating func dequeue() -> T? {
        guard storage.count == 0 else { return storage.remove(at: 0)}
            
        return nil
    }
    
    public func forEach(_ body: (T) throws -> Void) rethrows{}
    
    public func contains(where predicate: (T) -> Bool) -> Bool{return true}
    public func findFirst(where predicate: (T) -> Bool) -> T?{ return nil}
    
    public mutating func remove(where predicate: (T) -> Bool){return}

}