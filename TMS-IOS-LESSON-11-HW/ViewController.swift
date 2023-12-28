import UIKit
import SnapKit

class ViewController: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    let calculator = Calculator()
    
    var buttonSize: Double!
    var spacing: Double!
    
    let topView = UIConstructor.createView()
    var topViewHeight: Double!
    
    var label: UILabel!
    
    var labelValue: String = "0" {
        didSet {
            if labelValue == "." {
                label.text = "0."
                labelValue = "0."
            } else {
                label.text = labelValue
            }
      
            if labelValue.count >= 6 {
                label.font = label.font.withSize(50)
            } else {
                label.font = label.font.withSize(70)
            }
        
        }
    }

    
    let bottomView = UIConstructor.createView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        buttonSize = screenSize.width * 0.18
        topViewHeight = screenSize.height * 0.37
        spacing = screenSize.width * 0.035
        
        label = calculator.label
        label.textAlignment = .right
        
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(topViewHeight)
            make.top.equalToSuperview()
        }
    
        topView.bounds = view.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        
        topView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(bottomView)
                
        bottomView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(screenSize.height - topViewHeight)
            make.bottom.equalToSuperview()
        }
        let topButtonsStackView =  setupTopButtons()
        let numberPadStack = setupNumberPad()
        let operatorsStack = setupOperators()
        
        
        bottomView.addSubview(topButtonsStackView)
  
        topButtonsStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((screenSize.width - (buttonSize * 4 + spacing * 3)) / 2)
            make.top.equalToSuperview().offset(screenSize.height * 0.05)
        }
        
        bottomView.addSubview(operatorsStack)
        operatorsStack.snp.makeConstraints { make in
            make.left.equalTo(topButtonsStackView.snp_rightMargin).offset(spacing)
            make.top.equalTo(topButtonsStackView.snp_topMargin)
        }
        
        bottomView.addSubview(numberPadStack)
        numberPadStack.snp.makeConstraints { make in
            make.left.equalTo(topButtonsStackView.snp_leftMargin)
            make.top.equalTo(topButtonsStackView.snp_bottomMargin).offset(spacing)
        }
    }
    
    private func setupTopButtons() -> UIStackView{
        let topButtons = ["AC", "√", "%"]
        
        let horizontalStackView = UIConstructor.createStackView(horizontal: true, spacing: spacing)
        
        topButtons.forEach { val in
            let btn = UIConstructor.createRoundedButton(title: val, size: buttonSize, backgroundColor: UIColor.topButton, tag: nil)
            btn.addAction(UIAction(handler: { _ in
                if(val == "AC") {
                    self.labelValue = "0"
                    self.calculator.clear()
                }
                
                if(val == "√") {
                    let result = sqrt(Double(self.labelValue)!)
                                      
                    self.labelValue = String(result == Double(Int(result)) ? String(Int(result)) : String(Double(result)))
                }
                
                if(val == "%") {
                    if self.calculator.currentOperation != nil {
                        let result = self.calculator.procentage(Double(self.labelValue)!)
                        self.labelValue = String(result == Double(Int(result)) ? String(Int(result)) : String(Double(result)))
                    } else {
                        let result = Double(self.labelValue)! / 100
                        self.labelValue = String(result == Double(Int(result)) ? String(Int(result)) : String(Double(result)))
                    }
                }
            }), for: UIControl.Event.touchUpInside)
            
            horizontalStackView.addArrangedSubview(btn)
            
            btn.snp.makeConstraints { make in
                make.width.equalTo(buttonSize)
                make.height.equalTo(buttonSize)
            }
        }
        return horizontalStackView
    }
    
    private func setupOperators() -> UIStackView {
        let operators = ["/", "*", "-", "+", "="]
        
        let verticalStackView = UIConstructor.createStackView(spacing: spacing)
        
        operators.forEach { val in
            let btn = UIConstructor.createRoundedButton(title: val, size: buttonSize, backgroundColor: UIColor.orange, tag: nil)
            
            btn.addAction(UIAction(handler: { _ in
                if(val == "+") {
                    self.calculator.sum(Double(self.labelValue)!)
                    self.labelValue = ""
                }
                
                if(val == "-") {
                    self.calculator.substraction(Double(self.labelValue)!)
                    self.labelValue = ""
                }
                
                if(val == "*") {
                    self.calculator.multipication(Double(self.labelValue)!)
                    self.labelValue = ""
                }
                
                if(val == "/") {
                    self.calculator.division(Double(self.labelValue)!)
                    self.labelValue = ""
                }
                
                if(val == "=") {
                    let result = self.calculator.equal(Double(self.labelValue)!)
                    self.labelValue =  String(result == Double(Int(result)) ? String(Int(result)) : String(Double(result)))
                }
            }), for: UIControl.Event.touchUpInside)
            
            verticalStackView.addArrangedSubview(btn)
            btn.snp.makeConstraints { make in
                make.width.equalTo(buttonSize)
                make.height.equalTo(buttonSize)
            }
        }
        return verticalStackView
    }
    
    
    private func setupNumberPad() -> UIStackView {
        let numbersMatrix: Array<Array<Int>> = [[7, 8, 9], [4, 5, 6], [1, 2, 3], [0, 100] ]
        
        let verticalStackView = UIConstructor.createStackView(spacing: spacing)
        
        numbersMatrix.forEach { row in
            let horizontalStack = UIConstructor.createStackView(horizontal: true, spacing: spacing)
            
            row.forEach { num in
                let value = num == 100 ? "." : String(num)
                let btn = UIConstructor.createRoundedButton(title: value, size: buttonSize, backgroundColor: UIColor.numberPadButton, tag: nil)
                
                horizontalStack.addArrangedSubview(btn)
                
                btn.snp.makeConstraints { make in
                    if num == 0 {
                        btn.contentHorizontalAlignment = .left
                        btn.contentEdgeInsets =  UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 0)
                        make.width.equalTo(buttonSize * 2 + spacing)
                    } else {
                        make.width.equalTo(buttonSize)
                    }
                    make.height.equalTo(buttonSize)
                }
                
                btn.addAction(UIAction(handler: { _ in
                    let currentText = self.labelValue
                    self.labelValue = currentText == "0" ? value : self.labelValue + value
                }), for: UIControl.Event.touchUpInside)
                
                
            }
            verticalStackView.addArrangedSubview(horizontalStack)
            
            horizontalStack.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
        }
        return verticalStackView
    }
}

