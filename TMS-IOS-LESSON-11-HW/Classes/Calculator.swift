import Foundation
import UIKit

enum Operations  {
    case sum
    case subtraction
    case division
    case multipication
    case procentage
}

class Calculator {
    private let initialLabel = "0"
    private var previousResult: Double? = nil
    
    var currentOperation: Operations? = nil
    
    var procentageOperation: Operations? = nil
    
    let label: UILabel!
    
    init() {
        self.label = UIConstructor.createLabel(text: initialLabel, font: UIFont.systemFont(ofSize: 70), tag: nil)
    }
    
    func sum(_ num: Double) {
        if previousResult == nil {
            previousResult = num
            currentOperation = Operations.sum
         
        }
    }
    
    func substraction(_ num: Double)  {
        if previousResult == nil {
            previousResult = num
            currentOperation = Operations.subtraction
        }
    }
    
    func multipication(_ num: Double)   {
        if previousResult == nil {
            previousResult = num
            currentOperation = Operations.multipication
        }
    }
    
    func division(_ num: Double)  {
        if previousResult == nil {
            previousResult = num
            currentOperation = Operations.division
        }
    }

    func procentage(_ num: Double) -> Double {
            procentageOperation = currentOperation
            currentOperation = .procentage
        
            return (previousResult! * (num / 100))
    }
    
    func equal(_ num: Double) -> Double {
        let innerPrevious = previousResult
        let innerCurrentOperation = currentOperation
        previousResult = nil
        currentOperation = nil
        
        if(innerCurrentOperation == Operations.sum) {
            let result = innerPrevious! + num
            return result
        }
        
        if(innerCurrentOperation == Operations.subtraction) {
            let result = innerPrevious! - num
            return result
        }
        
        if(innerCurrentOperation == Operations.multipication) {
            let result = innerPrevious! * num
            return result
        }
        
        if(innerCurrentOperation == Operations.division) {
            let result = innerPrevious! / num
            return result
        }
    
        if(innerCurrentOperation == Operations.procentage) {
            if(procentageOperation == .sum) {
                return innerPrevious! + num
            }
            if(procentageOperation == .subtraction) {
                return innerPrevious! - num
            }
            if(procentageOperation == .multipication) {
                return innerPrevious! * num
            }
            if(procentageOperation == .division) {
                return innerPrevious! / num
            }
            procentageOperation = nil
        }
        return 0
    }
    
    func clear() {
        label.text = initialLabel
        previousResult = nil
        currentOperation = nil

    }
    
}
