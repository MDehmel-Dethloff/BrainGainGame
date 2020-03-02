//
//  ViewController.swift
//  BrainGame
//
//  Created by Marko Dehmel-Dethloff on 24.02.20.
//  Copyright © 2020 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var firstPlaceLabel: UILabel!
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    
    var scoreArray: [Int] = []
    
    // Initialisierungsmethode, in der der Highscore geladen wird
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        loadScores()
        setHighscores()
    }
    
    // Lädt den Highscore neu, wenn auf den Startbildschirm gewechselt wird
    override func viewWillAppear(_ animated: Bool) {
        loadScores()
        setHighscores()
    }
    
    // Wechselt zur Spiele-Szene
    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueToGameScene", sender: self)
    }
    
    // Lädt die gespeicherten Scores in das scoreArray
    func loadScores() {
        
        // Kontext idtentifizieren
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Score"
        
        // Request für Scores stellen
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let scores = try context.fetch(request)
            
            scoreArray.removeAll()
            // lädt die gespeicherten Scores in das scoreArray
            for s in scores {
                
                if let score = s as? NSManagedObject {
                    guard let numberOfPoints = score.value(forKey: "numberOfPoints") as? Int else {
                        return
                    }
                    scoreArray.append(numberOfPoints)
                }
            }
        } catch {
            print("Error ist aufgetreten!")
        }
    }
    
    // Lädt die besten drei Score und zeigt sie auf dem Startbildschirm an
    func setHighscores() {
        scoreArray.sort()
        if scoreArray.count > 0 {
            firstPlaceLabel.text = "1. \(scoreArray.last!)"
        }
        if scoreArray.count > 1 {
            secondPlaceLabel.text = "2. \(scoreArray[scoreArray.count-2])"
        }
        if scoreArray.count > 2 {
            thirdPlaceLabel.text = "3. \(scoreArray[scoreArray.count-3])"
        }
    }
    
    // Wechselt zur Anleitungsszene
    @IBAction func segueToManualAction(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueToManual", sender: self)
    }
}

