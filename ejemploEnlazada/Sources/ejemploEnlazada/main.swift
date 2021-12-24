// Nodo genérico
class Node<T> {
    var value: T
    var next: Node?
    
    init(value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node : CustomStringConvertible {
    public var description: String {
        guard let next = next else { return "[\(value)]" }
        return "[\(value)] -> \(next)"
    }
}

struct LinkedList<T> {
    typealias ListNode = Node<T> // Nombre simbólico para el tipo
    
    var head: ListNode?
    var tail: ListNode?
}

extension LinkedList {    
    mutating func append(_ value: T) {
        // Create node
        let newNode = ListNode(value: value)
        
        // The tail, if it exists, must point to the new node
        if let tail = tail {
            tail.next = newNode
        }
        
        // Update tail and head
        tail = newNode
        if head == nil { head = newNode }
    }
}

extension LinkedList {
    func node(at index: Int) -> ListNode? {
        var i = 0
        var node = head
        while node != nil && i < index {
            node = node!.next
            i = i+1
        }
        return node
    }
}
extension LinkedList {
    mutating func push(_ value: T) {
        let newNode = Node(value: value, next: head)
        head = newNode
        if tail == nil { tail = newNode }
    }
}


extension LinkedList {
    mutating func insert(_ value: T, at index: Int) {
        guard index > 0 else {
            push(value)
            return
        }
        var prev = node(at: index-1)
        let node = ListNode(value: value, next: prev?.next)
        prev?.next = node
        if node.next == nil { tail = node }
    }
}


extension LinkedList {
    mutating func pop() -> T? {
        let node = head
        head = head?.next
        if head == nil { tail = nil }
        return node?.value
    }
}

extension LinkedList {
    mutating func removeLast() -> T? {
        guard head != nil  else { return nil }

        guard head !== tail else {
            let value = tail?.value
            head = nil
            tail = nil
            return value
            
        }

        var current = head
        // "!== comparacion de tipo"
        while current?.next !== tail {current = current?.next}

        let value = tail?.value

        tail = current
        current?.next = nil

        return value
        
    }

    
}

extension LinkedList {

    mutating func removeAt(index: Int) -> T? {
        guard index > 0 else {
            return pop()
        }
        var prev = node(at: index-1)
        var cepillar = prev?.next
        prev?.next = cepillar?.next

        if cepillar?.next == nil {
            tail = cepillar
        }

        return cepillar?.value

        
    }

    
}

func testvalues(_ actual: String, _ expected: String) -> Bool {
    guard actual == expected else {
        print("Se esperaba \(expected) pero se ha obtenido \(actual)")
        return false
        
    }
    return true
}

func createList() -> LinkedList<String> {

    var lista = LinkedList<String>()
    lista.append("uno")
    lista.append("dos")
    lista.append("tres")

    return lista    
}

var lista = createList()

if let borrado = lista.pop() {
    if borrado != "uno" {
        print("Error")
    }
}
print("Borrando primero prueba terminada")


lista = createList()
if let borrado = lista.removeLast() {
    _ = testvalues(borrado, "tres")
    
} else {
    print("Error")
    
}
print("Prueba removeLast terminada")


lista = createList()
if let borrado = lista.removeAt(index: 1) {
    _ = testvalues(borrado, "dos")
    
} else {
    print("Error: removeAt() no debería devolver nil")
    
}

print("removeAt() prueba terminada")
