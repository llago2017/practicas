//import Socket

public struct ArrayQueue<T>: Queue {
    public var storage = [T]()

    public var count: Int = 0
    public var maxCapacity: Int

    public init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
    }
    
    public mutating func enqueue(_ value: T) throws{
        if count < maxCapacity {
            storage.append(value)
            count += 1
            
        } else {
            throw CollectionsError.maxCapacityReached
        }
        
        
    }

    public mutating func dequeue() -> T? {
        guard storage.count == 0 else { 
            count -= 1
            return storage.remove(at: 0)}
            
        return nil
    }
    
    public func forEach(_ body: (T) throws -> Void) rethrows{
        // No se envia al que manda el writer, que al actualizarse es el ultimo
        let lastUser = storage.count - 1
        if storage.count > 0 {
            for i in 0...lastUser {
                try! body(storage[i])
            }
        }
        
    }
    
    public func contains(where predicate: (T) -> Bool) -> Bool{
       return self.storage.contains(where: predicate)
    }

    public func findFirst(where predicate: (T) -> Bool) -> T?{
        return self.storage.first(where: predicate)
    }
    
    public mutating func remove(where predicate: (T) -> Bool){
        var result: Int?
        result = self.storage.firstIndex(where: predicate)

        //print("Elimino en el index \(result)")
        self.storage.remove(at: result!)
        
        count -= 1
             
        
    }

}