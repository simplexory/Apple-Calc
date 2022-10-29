//
//  ViewController.swift
//  Apple Calc
//
//  Created by Юра Ганкович on 26.10.22.
//

import UIKit

class DisplayViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private let manager = CalcManager()
    private var userInTyping = false
    
    var displayValue: Double {
        get  {
            if let number = displayLabel.text  {
                return Double(number)!
            }
            return 0
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    // MARK: flow func
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        if userInTyping {
            manager.setOperand(displayValue)
            userInTyping = false
        }
        
        if let symbol = sender.titleLabel?.text {
            manager.performOperation(symbol)
        }
        
        if let result = manager.result {
            displayValue = result
        }
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        if let digit = sender.titleLabel?.text {
            if userInTyping {
                if let displayValue = displayLabel.text {
                    displayLabel.text = displayValue + digit
                }
            } else {
                displayLabel.text = digit
                userInTyping = true
            }
        }
    }
    
}

