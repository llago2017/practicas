class BankAccount {
    let numeroCuenta: String
    private var saldo: Double // Solo se puede acceder desde dentro de la propia clase

    init(numeroCuenta: String, server: String) {
        self.numeroCuenta = numeroCuenta
        // Se conecta al servidor del banco y obtiene
        // el saldo para ese número de cuenta
        // ...
        let saldoObtenidoDeLaBaseDeDatos = 550.7
        self.saldo = saldoObtenidoDeLaBaseDeDatos
    }
}

let account = BankAccount(
numeroCuenta: "010438853607",
server: "ING")
account.saldo = 10000000 // 'saldo' is inaccessible due to 'private' protection level
