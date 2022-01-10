
public class Node<T> {  
    public var value:T  
    public var next:Node?  
    
    init(value:T) {
        self.value = value  
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else { return "[\(value)]" }
        return "[\(value)] -> \(next)"
    }
}

public struct LinkedList<T> {
    typealias ListNode = Node<T>
    var head: ListNode?  
    var tail: ListNode?
    
    mutating func append(_ value: T) {
        let newNode = Node(value: value)

        if let tail = tail {
            tail.next = newNode
        }
        tail = newNode
        if head == nil { head = newNode }
    }
    
    mutating func pop() -> T? {
        let node = head
        head = head?.next
        if head == nil { tail = nil }
        return node?.value    // Devuelvo el nodo que acabo de borrar
    }
    
    func findFirst() -> T? {
        guard head != nil else {return nil}
        return head?.value
    }
    
    func contains(where predicate: (T) -> Bool) -> Bool {
        var result: Bool = false
        var node = head
        while let nd = node {
            if predicate(nd.value) {
                result = true
            }
            node = nd.next
        }
        return result

    }
    
    func node(at index: Int) -> Node<T>? {
        var i = 0
        var node = head
        while node != nil && i < index {
            node = node!.next
            i = i+1
        }
        return node
    }
    
    mutating func remove(at index: Int) -> T? {
        guard index > 0 else {
            return pop()
        }
        
        var prev = node(at: index - 1)
        var cepillar = prev?.next
        prev?.next = cepillar?.next
        
        if cepillar?.next == nil {
            tail = prev
            tail?.next = nil
        }
        
        return cepillar?.value
    }
    
    mutating func removeNode(where predicate: (T) -> Bool) -> T? {
        var node = head
        var index = 0
        
        while let nd = node {
            if predicate(nd.value) {
                return remove(at: index)
            }
            node = nd.next
            index += 1
        }
        return nil
    }
    
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty list." }
        return "\(head)"
    }
}

public struct LinkedQueue<T> {
    public var count:Int = 0
    public var myList = LinkedList<T>()
    
    public var maxCapacity: Int

    public init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
    }
    
    public mutating func enqueue(_ value: T) throws {
        if count <= maxCapacity {
            myList.append(value)
            count += 1
        } else {
            throw CollectionsError.maxCapacityReached
        }
    }
    
    public mutating func dequeue () -> T? {
        count -= 1
        return myList.pop()
    }
    
    public func findFirst(where predicate: (T) -> Bool) -> T? {
        return myList.findFirst()
    }
    
    public func contains(where predicate: (T) -> Bool) -> Bool {
        return myList.contains(where: predicate)
    }
    
    public mutating func remove(where predicate: (T) -> Bool) {
        count -= 1
        myList.removeNode(where: predicate)
        
    }
    
    public func forEach(_ body: (T) throws -> Void) rethrows {
        //var index = 0
        for index in 0...maxCapacity {
            var node = myList.node(at: index)
            if node != nil {try body(node!.value)}
        }
        
    }
    
    
}


extension LinkedQueue: CustomStringConvertible {
    public var description: String {
        return "\(myList)"
    }
}