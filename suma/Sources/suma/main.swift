var suma = 0
var keepAlive = true

while keepAlive {
    print("Introduzca un numero: ")
    if let input = readLine() {
        if let num = Int(input) {
            // the user entered a valid integer
            suma += num
        } else {
            // the user entered something other than an integer
            print("Resultado: \(suma)")
            keepAlive = false;
            
        }
    }
}
