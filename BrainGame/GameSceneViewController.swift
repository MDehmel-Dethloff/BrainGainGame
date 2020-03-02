//
//  GameSceneViewController.swift
//  BrainGame
//
//  Created by Marko Dehmel-Dethloff on 24.02.20.
//  Copyright © 2020 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit
import CoreData

class GameSceneViewController: UIViewController {
    
    // Deklarieren und Initialisieren von Variablen
    @IBOutlet weak var countdown: UILabel!
    var colorArray: [UIColor] = []
    var guessArray: [String] = []
    var checkArray: [String] = []
    var gameArray: [UIColor] = []
    var controlArray: [String] = []
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    var guessCounter: Int = 0
    var score = 0
    var numberOfUsedColors = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    // Initialisierungsmethode, die die benötigten Methoden auffruft, um das Spiel zu starten
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        
        colorButton.isEnabled = false
        createColorArray()
        createGameArray()
        gameLoop()
        
        // Countdown für den Spielstart
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.countdown.text = "3"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.countdown.text = "2"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.countdown.text = "1"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.countdown.text = "Los!"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.countdown.text = ""
        })
        
    }
    
    // Speichert den Score ab, sodass er ggfs. als Highscore angezeigt werden kann
    func saveScore() {
        
        // Kontext identifizieren
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Score"
        
        // Neuen Datensatz anlegen
        guard let newEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return
        }
        
        let newScore = NSManagedObject(entity: newEntity, insertInto: context)
        
        let currentScore = score
        
        newScore.setValue(currentScore, forKey: "numberOfPoints")
        
        // Neuen Score speichern
        do {
            try context.save()
        } catch {
            print("Ein Error ist aufgetreten!")
        }
    }
    
    // Erstellt die Farb-Folgen, auf basis des gameArrays
    func gameLoop() {
        
        var counter = 1
        
        for index in 0...gameArray.count-1 {
            counter += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0 + Double(index), execute: {
                self.colorButton.backgroundColor = self.gameArray[index]
            })
        }
        // Setzt den Button nach der Farb-Folge wieder auf grau
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0 + Double(counter), execute: {
            self.colorButton.backgroundColor = UIColor.systemGray
            self.colorButton.setTitle("Farben: \(self.numberOfUsedColors)", for: .normal)
        })
        
    }
    
    // Erstellt eine zufällig Farb-Folge und speichert diese in das gameArray. Die Lönge der Farb-Folge ist abhängig von den bereits verdienten Punkten.
    func createGameArray() {
        
        if score < 120 {
            numberOfUsedColors = 4
            for _ in 0...3 {
                let randNumber = Int.random(in: 0...3)
                gameArray.append(colorArray[randNumber])
                controlArray.append(checkArray[randNumber])
            }
            return
        }
        if score < 240 {
            numberOfUsedColors = 5
            for _ in 0...4 {
                let randNumber = Int.random(in: 0...3)
                gameArray.append(colorArray[randNumber])
                controlArray.append(checkArray[randNumber])
            }
            return
        }
        if score < 390 {
            numberOfUsedColors = 6
            for _ in 0...5 {
                let randNumber = Int.random(in: 0...3)
                gameArray.append(colorArray[randNumber])
                controlArray.append(checkArray[randNumber])
            }
            return
        }
        if score < 500 {
            numberOfUsedColors = 7
            for _ in 0...6 {
                let randNumber = Int.random(in: 0...3)
                gameArray.append(colorArray[randNumber])
                controlArray.append(checkArray[randNumber])
            }
            return
        }
        if score >= 500 {
            numberOfUsedColors = 8
            for _ in 0...7 {
                let randNumber = Int.random(in: 0...3)
                gameArray.append(colorArray[randNumber])
                controlArray.append(checkArray[randNumber])
            }
            return
        }
        
    }
    
    // Initialisiert das colorArray, in dem alle verwendeten Farben gespeichert werden und das checkArray, in dem die dazugehörigen Strings gespeichert werden. Diese werden benötigt, um die Eingaben des Benutzers mit der ersten Farb-Folge abzugleichen.
    func createColorArray() {
        colorArray.append(UIColor.systemPink)
        checkArray.append("pink")
        colorArray.append(UIColor.systemBlue)
        checkArray.append("blue")
        colorArray.append(UIColor.systemOrange)
        checkArray.append("orange")
        colorArray.append(UIColor.systemPurple)
        checkArray.append("purple")
    }
    
    // Leitet eine neue Runde ein
    func startNewRound() {
        
        var counter = 0
        guessCounter = 0
        gameArray.removeAll()
        controlArray.removeAll()
        guessArray.removeAll()
        countdown.text = ""
        
        createGameArray()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.countdown.text = "Los!"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.countdown.text = ""
        })
        for index in 0...gameArray.count-1 {
            counter += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5 + Double(index), execute: {
                self.colorButton.backgroundColor = self.gameArray[index]
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5 + Double(counter), execute: {
            self.colorButton.backgroundColor = UIColor.systemGray
            self.colorButton.setTitle("Farben: \(self.numberOfUsedColors)", for: .normal)
        })
    }
    
    // Zeigt die richtige Farbe an, wenn der Benutzer sich für eine falsche Farbe entschieden hat. Die richtige Farbe blinkt drei mal grün auf.
    func showRightSolution() {
        
        if controlArray[guessCounter] == "pink" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.firstButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                self.firstButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.firstButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
                self.firstButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
                self.firstButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
        }
        if controlArray[guessCounter] == "blue" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.secondButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                self.secondButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.secondButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
                self.secondButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
                self.secondButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
        }
        if controlArray[guessCounter] == "orange" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.thirdButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                self.thirdButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.thirdButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
                self.thirdButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
                self.thirdButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
        }
        if controlArray[guessCounter] == "purple" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.fourthButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                self.fourthButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.fourthButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
                self.fourthButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
                self.fourthButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
                
            })
        }
        
    }
    
    // Wählt die Farbe Pink aus und überprüft, ob dies die richtige Farbe ist. Wenn nein, wird das Spiel beendet.
    @IBAction func firstButtonAction(_ sender: UIButton) {
        
        if guessCounter >= numberOfUsedColors {
            return
        }
        guessArray.append("pink")
        if controlArray[guessCounter] == guessArray[guessCounter]{
            firstButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.firstButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            score += 10
            scoreLabel.text = "Score: \(score)"
        } else {
            countdown.text = "Game Over!"
            firstButton.layer.borderColor = CGColor.init(srgbRed: 0.67, green: 0.039, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            showRightSolution()
            saveScore()
            return
        }
        guessCounter += 1
        if guessCounter == numberOfUsedColors {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.nextButton.setTitle("Weiter", for: .normal)
                self.nextButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            return
        }
        
    }
    
    // Wählt die Farbe Blau aus und überprüft, ob dies die richtige Farbe ist. Wenn nein, wird das Spiel beendet.
    @IBAction func secondButtonAction(_ sender: UIButton) {
        
        if guessCounter >= numberOfUsedColors {
            return
        }
        guessArray.append("blue")
        if controlArray[guessCounter] == guessArray[guessCounter]{
            secondButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.secondButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            score += 10
            scoreLabel.text = "Score: \(score)"
        } else {
            countdown.text = "Game Over!"
            secondButton.layer.borderColor = CGColor.init(srgbRed: 0.67, green: 0.039, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            showRightSolution()
            saveScore()
            return
        }
        guessCounter += 1
        if guessCounter == numberOfUsedColors {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.nextButton.setTitle("Weiter", for: .normal)
                self.nextButton.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            return
        }
        
    }
    
    // Wählt die Farbe Orange aus und überprüft, ob dies die richtige Farbe ist. Wenn nein, wird das Spiel beendet.
    @IBAction func thirdButtonAction(_ sender: UIButton) {
        
        if guessCounter >= numberOfUsedColors {
            return
        }
        guessArray.append("orange")
        if controlArray[guessCounter] == guessArray[guessCounter]{
            thirdButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.thirdButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            score += 10
            scoreLabel.text = "Score: \(score)"
        } else {
            countdown.text = "Game Over!"
            thirdButton.layer.borderColor = CGColor.init(srgbRed: 0.67, green: 0.039, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            showRightSolution()
            saveScore()
            return
        }
        guessCounter += 1
        if guessCounter == numberOfUsedColors {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.nextButton.setTitle("Weiter", for: .normal)
                self.nextButton.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            return
        }
        
    }
    
    // Wählt die Farbe Lila aus und überprüft, ob dies die richtige Farbe ist. Wenn nein, wird das Spiel beendet.
    @IBAction func fourthButtonAction(_ sender: UIButton) {
        
        if guessCounter >= numberOfUsedColors {
            return
        }
        guessArray.append("purple")
        if controlArray[guessCounter] == guessArray[guessCounter]{
            fourthButton.layer.borderColor = CGColor.init(srgbRed: 0.039, green: 0.67, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.fourthButton.layer.borderColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            score += 10
            scoreLabel.text = "Score: \(score)"
        } else {
            countdown.text = "Game Over!"
            fourthButton.layer.borderColor = CGColor.init(srgbRed: 0.67, green: 0.039, blue: 0.13, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            showRightSolution()
            saveScore()
            return
        }
        guessCounter += 1
        if guessCounter == numberOfUsedColors {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.nextButton.setTitle("Weiter", for: .normal)
                self.nextButton.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
            })
            return
        }
        
    }
    
    // Startet die nächste Runde.
    @IBAction func nextRoundAction(_ sender: UIButton) {
        
        if guessCounter == numberOfUsedColors {
            startNewRound()
            self.nextButton.setTitle("", for: .normal)
            self.nextButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
            self.colorButton.setTitle("", for: .normal)
        }
    }
    
    
}
