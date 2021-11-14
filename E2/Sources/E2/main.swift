var arguments = CommandLine.arguments
var option: String
var message: ArraySlice<String>
var message_string: String = ""
var message_encode: String = ""

let code = [
"a" : "b", "b" : "c", "c" : "d", "d" : "e",
"e" : "f", "f" : "g", "g" : "h", "h" : "i",
"i" : "j", "j" : "k", "k" : "l", "l" : "m",
"m" : "n", "n" : "o", "o" : "p", "p" : "q",
"q" : "r", "r" : "s", "s" : "t", "t" : "u",
"u" : "v", "v" : "w", "w" : "x", "x" : "y",
"y" : "z", "z" : "a" , " ":" "
] 


if arguments.count > 1 {
    option = arguments[1];
    message = arguments[2...]

    // Paso el mensaje a una cadena String
    for palabra in message {
        message_string += palabra + " "
    }

    switch option {
        case "decode":
            print("En proceso")
            
        break;

        case "encode":
            for letra in message_string {
                //print(type(of:letra));
                message_encode += code[String(letra)]!
            }

        break;

        default:
            print("Opcion no valida")
            
        
    }

    print("Opcion elegida: \(option)")
    print(message_encode)
    
}


