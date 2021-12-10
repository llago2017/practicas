import Dispatch

func run(_ label: String, times: Int = 5) {
    for n in 1...times {
        print(label, n)
        
    }
}

/*
run()
run()
run()
*/
// Cola de ejecución
let queue = DispatchQueue.global() // Envío trabajos que ejecuta en paralelo

// Mando trabajos a la cola, que son bloques de código
queue.async {
    run("T1")
}

queue.async {
    run("T2")
}

queue.async {
    run("T3")
}

run("TP")