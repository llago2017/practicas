protocol Queue {
    associatedtype Element
    
    mutating func enqueue(_ value: Element)
    mutating func dequeue() -> Element?
    
    var isEmpty: Bool { get }
    func peek() -> Element?
}

public class Node<T> {
    var value: T   
    var next: Node?     
    
    public init(value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

public struct LinkedList<T> {
    typealias ListNode = Node<T>
    var head: ListNode?   
    var tail: ListNode?

    public init() {}
}

extension LinkedList {
    public mutating func append(_ value: T) {
        let newNode = Node(value: value)

        if let tail = tail {
            tail.next = newNode
        }
        tail = newNode
        if head == nil { head = newNode }
    }
    
    public mutating func pop() -> T? {
        let node = head
        head = head?.next
        if head == nil { tail = nil }
        return node?.value    // Devuelvo el nodo que acabo de borrar
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
    
    public mutating func remove(at index: Int) -> T? {
        guard index > 0 else {
            return pop()
        }
        
        let prev = node(at: index - 1)
        let cepillar = prev?.next
        prev?.next = cepillar?.next
        
        if cepillar?.next == nil {
            tail = prev
            tail?.next = nil
        }
        
        return cepillar?.value
    }
    
    public mutating func removeLast() -> T? {
        guard let head = head else { return nil }
        var test = head
        var i = 0
        // Busco el numero del ultimo var prev = node(at: count-1)
        while test.next != nil {
            test = test.next!
            i += 1
        }
        
        let prev = node(at: i-1)
        tail = prev
        tail?.next = nil
        
        return test.value
    }
    
    public func findFirst() -> T? {
        guard head != nil else {return nil}
        return head?.value
    }
}

public struct ListQueue<T> : Queue {
    private var storage = LinkedList<T>()

}
    
extension ListQueue {
    public mutating func enqueue(_ value: T) {
        // Your code here
        storage.append(value)
    }
    
    public mutating func dequeue() -> T? {
        // Your code here
        return storage.pop()
    }
    
    public var isEmpty: Bool {
        // Your code here
        let test = storage.findFirst()
        guard test != nil else {return true}
        return false
        
    }
    
    public func peek() -> T? {
        // Your code here
        return storage.findFirst()
    }
}

func testListQueue() {
    var q = ListQueue<String>()
    if !q.isEmpty { print("isEmpty should be true when the queue is empty") }
    if q.dequeue() != nil { print("dequeue should return nil on an empty queue") }
    if q.peek() != nil { print("peek should return nil on an empty queue") }
    
    ["the", "rain", "in", "Spain"].forEach { q.enqueue($0) }
    
    var v = q.peek()
    if v != "the" { print("peek error, should return 'the' but your implementation returned \(v)") }
    v = q.peek()
    if v != "the" { print("peek error, should return 'the' but your implementation returned \(v)") }

    v = q.dequeue()
    if v != "the" { print("dequeue error, should return 'the' but your implementation returned \(v)") }

    q.dequeue()  // rain
    q.dequeue()  // in
    
    v = q.peek()  // Spain
    if v != "Spain" { print("peek error, should return 'Spain' but your implementation returned \(v)") }

    v = q.dequeue()
    if v != "Spain" { print("dequeue error, should return 'Spain' but your implementation returned \(v)") }

    if q.dequeue() != nil { print("dequeue error, should return nil") }
    if q.peek() != nil { print("peek error, should return nil") }
    if !q.isEmpty { print("isEmpty should be true when the queue is empty") }

    q.enqueue("test")
    if q.isEmpty { print("queue should not be empty") }
}

testListQueue()
print("Fin de pruebas de ListQueue")