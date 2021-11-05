
var testGame = MasterMindGame();
for _ in 1..<10 {
    if testGame.currentTurn < 10{
        print("Enter your guess: ")
        let guess = readLine()!
        testGame.newTurn(guess)
    }
    
}
  

