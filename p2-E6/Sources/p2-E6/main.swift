public class Node<T> {  
    public var value:T  
    public var next: Node?  
    public var prev: Node?
    
    init(value: T, prev: Node<T>?, next: Node<T>?) {
        self.value = value
        self.prev = prev
        self.next = next  
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

    var isEmpty: Bool {
        head == nil 
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

    mutating func push(_ value: T){
        let newNode = Node(value: value, prev: nil, next: head)
        head = newNode
        if isEmpty {
            tail = head
        } 
            
    }
    
    mutating func append(_ value: T) {
        let newNode = Node(value: value, prev: nil, next: nil)

        // Ya hay elementos
        if let tail = tail {
            newNode.prev = tail
            tail.next = newNode
        }

        tail = newNode
        // Si es el primer elemento
        if head == nil {
            head = newNode 
        }
    }
    
    mutating func pop() -> T? {
        let node = head
        head = head?.next
        if head == nil { tail = nil }
        head?.prev = nil
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
    
      
    mutating func remove(at index: Int) -> T? {
        guard index > 0 else {
            return pop()
        }

        var mynode = node(at: index)
        
        var prev = mynode?.prev
        var cepillar = prev?.next
        prev?.next = cepillar?.next
        
        if cepillar?.next == nil {
            tail = prev
            tail?.next = nil
        }
        
        return cepillar?.value
    }

    mutating func removeLast() -> T? {
        // Si no esta vacio
        if var tail = tail {
            let deletedNode = tail 
            tail = (tail.prev)!
            tail.next = nil
            return deletedNode.value
        }

        return nil
    }
    
    

    public func forEach(_ processElement: (T) throws -> Void) rethrows {
        //var index = 0
        var node = head
        repeat{
            try processElement(node!.value)
            node = node?.next
        } while node != nil
        
    }

    public func reversedForEach(_ processElement: (T) throws -> Void) rethrows {
        //var index = 0
        var node = tail
        repeat {
            try processElement(node!.value)
            node = node?.prev
            
        } while node != nil
        if head != nil {
            try processElement(head!.value)
        }
    }
    
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty list." }
        return "\(head)"
    }
}

var test = LinkedList<String>()
test.append("uno")
test.append("dos")
test.append("tres")
test.push("cero")

test.forEach(testEach)
print("Reversed")

test.reversedForEach(testEach)

print("Fin de test append y push")

print(test.removeLast()) //3
print(test.remove(at: 1)) // 1
print(test.remove(at: 2)) // No existe
print(test) // 0 2

func testEach(value: String) {
    print(">> ", value)
}



