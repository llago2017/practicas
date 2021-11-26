print("Hello, world!")

class Node {

var value: String
var next: Node?

   init(value: String, next: Node? = nil) {
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
// Nueva estructura

struct LinkedList {
    private(set) var head: Node?
    private(set) var tail: Node?

    init() {}
    
}


extension LinkedList {
    mutating func append(_ value: String) {
        // Create node
        let newMode = Node(value: value)

        if let tail = tail {
            tail.next = newMode
        } 

        tail = newMode
        if head == nil  {head = newMode}        
    
    }
    
}

extension LinkedList : CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty list." }
        return "\(head)"
    }
}
    


var lista = LinkedList()
lista.append("a")
lista.append("b")
lista.append("c")
print(lista)

// Insertando nodos al principio de l alista

extension LinkedList {
    mutating func push(_ value: String)  {
        var newNode = Node(value: value, next: head)
        head = newNode
        // Si la lista está vacía tail apunta al nuevo
        if tail == nil  { tail = newNode }
    }
    
}

lista.push("julia")
print(lista.tail)


// Iteracion

extension LinkedList {
    func value(at index: Int) -> String? {
        var i = 0
        var node = head
        while node != nil && i < index {
            node = node!.next
            i = i+1
        }
        // Con ? porque puede ser nil
        return node?.value
    }
    
}

var otraLista = LinkedList()
print(otraLista.value(at: 5))