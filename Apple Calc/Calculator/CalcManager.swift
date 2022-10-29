//
//  CalcManager.swift
//  Apple Calc
//
//  Created by Юра Ганкович on 27.10.22.
//

import Foundation

class CalcManager {
    static let shared = CalcManager()
    init() { }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let leftOperand: Double
        
        func perform(with rightOperand: Double) -> Double {
            return function(leftOperand, rightOperand)
        }
    }
    
    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var operations: Dictionary<String, Operation> = [
        "%" : Operation.unaryOperation { $0 / 100 },
        "±" : Operation.unaryOperation { -$0 },
        "÷" : Operation.binaryOperation { $0 / ($1 != 0 ? $1 : 1) },
        "×" : Operation.binaryOperation { $0 * $1 },
        "−" : Operation.binaryOperation { $0 - $1 },
        "+" : Operation.binaryOperation { $0 + $1 },
        "=" : Operation.equals,
        "AC" : Operation.clear
    ]
    
    var result: Double? {
        get { return accumulator }
    }
    
    private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
        }
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, leftOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                pendingBinaryOperation = nil
                accumulator = 0
            }
        }
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
}
