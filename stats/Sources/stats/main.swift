var suma = 0
var numbers = [Int]()
var keepAlive = true

while keepAlive {
    print("Introduzca un numero: ")
    if let input = readLine() {
        if let num = Int(input) {
            // the user entered a valid integer
            suma += num
            numbers.append(num)
        } else {
            // the user entered something other than an integer
            print("Resultado: \(suma)")
            print("Maximo: \(numbers.max()!)")
            print("Minimo: \(numbers.min()!)")
            print("Media: \(Double(suma/numbers.count))")
            
            
            
            keepAlive = false;
            
        }
    }
}
