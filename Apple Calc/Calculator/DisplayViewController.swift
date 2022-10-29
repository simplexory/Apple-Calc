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
    private var floatPointIsSet = false
    
    var displayValue: Double {
        get  {
            if let value = displayLabel.text {
                return Double(formatFloatPointCharacter(value))!
            }
            
            return 0
        }
        set {
            var value = String(newValue)
            
            if value.suffix(2) == ".0" {
                value.removeLast(2)
            }
            
            displayLabel.text = formatFloatPointCharacter(value)
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
    
    @IBAction func decimalPressed() {
            let decimal = ","
            if userInTyping {
                if displayLabel.text != nil {
                    if !displayLabel.text!.contains(decimal) {
                        displayLabel.text = displayLabel.text! + decimal
                    }
                }
            }
            else {
                displayLabel.text = "0,"
                userInTyping = true
            }
        }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        if let digit = sender.titleLabel?.text {
            if digit == "0" && displayValue == 0 { return }
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
    
    private func formatFloatPointCharacter(_ value: String) -> String {
        if value.contains(",") {
            return value.replacingOccurrences(of: ",", with: ".")
        }
        
        if value.contains(".") {
            return value.replacingOccurrences(of: ".", with: ",")
        }
        
        return value
    }
    
}

