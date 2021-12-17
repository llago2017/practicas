import Socket

struct ArrayQueue<T>: Queue {
    private var storage = [T]()

    var count: Int = 0
    var maxCapacity: Int
    
    mutating func enqueue(_ value: T) throws{
        storage.append(value)
    }

    mutating func dequeue() -> T? {
        guard storage.count == 0 else { return storage.remove(at: 0)}
            
        return nil
    }
    
    func forEach(_ body: (T) throws -> Void) rethrows{}
    
    func contains(where predicate: (T) -> Bool) -> Bool{return true}
    func findFirst(where predicate: (T) -> Bool) -> T?{ return nil}
    
    mutating func remove(where predicate: (T) -> Bool){return}

}