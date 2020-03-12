//
//  ViewController.swift
//  resistors
//
//  Created by Student AM on 5/7/19.
//  Copyright © 2020 David Warshawsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    @IBAction func bandsSelector(_ sender: UISegmentedControl) {
        resetBands()
        colorsClicked.removeAll()
        numBands = sender.selectedSegmentIndex + 3
    }
    
    
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var resistor: UIStackView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var everything: UIStackView!
    
    
    // constraint declarations
    @IBOutlet weak var textViewWidth: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    
    
    
    @IBAction func everythingButton(_ sender: UIButton) {
        everything.isHidden = false
        textView.isHidden = true
    }
    
    
    @IBAction func helpClicked(_ sender: UIButton) {
        everything.isHidden = true
        textView.isHidden = false
    }
    

    
    // declare constants
    let resistorBandOptions = [3,4,5,6]
    let tolerances:[String] = ["±1%","±2%","±0.5%","±0.25%","±0.1%","±0.05%","±5%","±10%"]
    let temperatures:[String] =  ["100 ppm/K","50 ppm/K","15 ppm/K","25 ppm/K"]

    
    // declare variables
    var numBands = 3
    var currentBand = 0
    var bandsForResistor:[Int:[Int]] = [ 3:[1,4,7],4:[1,4,7,10],5:[1,4,7,10,13], 6:[1,4,7,10,14,17], ]
    var coloredButtons:[UIButton] = []
    var buttonColors:[UIColor] = []
    var colorsClicked:[Int] = []
    
    
    @IBOutlet weak var colors: UIStackView!
    
    // works
    func addButtons() {
        for row in colors.subviews {
            for cell in row.subviews {
                coloredButtons.append(cell as! UIButton)
                buttonColors.append(cell.backgroundColor as! UIColor)
                
            }
        }
    }
    
    
    func calculateAnswer(_ values:[Int]) -> String {
        
        var ohms: Double = 0
        var ohmsString = ""
        var tolerance:String = ""
        var temperature:String = ""
        
        
        if numBands == 3 {
            for value in values {
                print(value)
            }
            if values[2] > 0 && values[2] < 10 {
                ohms = Double("\(values[0])\(values[1])")! * Double(pow(Double(10),Double(values[2])))
            }
            else if values[2] == 10 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])")! / 10))!
            }
            else if values[2] == 11 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])")! / 100))!
            }
            else {
                ohms = Double("\(values[0])\(values[1])")!
            }
        }
        
        if numBands == 4 {
            
            if values[2] > 0 && values[2] < 10 {
                ohms = Double("\(values[0])\(values[1])")! * Double(pow(Double(10),Double(values[2])))
            }
            else if values[2] == 10 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])")! / 10))!
            }
            else if values[2] == 11 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])")! / 100))!
            }
            else {
                ohms = Double("\(values[0])\(values[1])")!
            }
            
        }
        
        if numBands == 5 {
            if values[3] > 0 && values[3] < 10 {
                ohms = Double("\(values[0])\(values[1])\(values[2])")! * Double(pow(Double(10),Double(values[3])))
            }
            else if values[3] == 10 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])\(values[2])")! / 10))!
            }
            else if values[3] == 11 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])\(values[2])")! / 100))!
            }
            else {
                ohms = Double("\(values[0])\(values[1])\(values[2])")!
            }
            
        }
        
        if numBands == 6 {
            
            if values[3] > 0 && values[3] < 10 {
                 ohms = Double("\(values[0])\(values[1])\(values[2])")! * Double(pow(Double(10),Double(values[3])))
            }
            else if values[3] == 10 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])\(values[2])")! / 10))!
            }
            else if values[3] == 11 {
                ohms = Double(String(format: "%.2f", Double("\(values[0])\(values[1])\(values[2])")! / 100))!
            }
            else {
                ohms = Double("\(values[0])\(values[1])\(values[2])")!
            }
            temperature = temperatures[values[5]-1]
            
        }
        
        
        if ohms >= 1_000_000_000 {
            ohmsString = "\(Double(ohms/1000000000))GΩ"
        }
        else if ohms >= 1_000_000 {
            ohmsString = "\(Double(ohms/1_000_000))MΩ"
        }
        else if ohms >= 1_000 {
            ohmsString = "\(Double(ohms/1_000))KΩ"
        }
        else {
            ohmsString = "\(Double(ohms))Ω"
        }
        
        
        // Check if tolerance exists, and if so set it.
        if numBands > 3 {
            if numBands == 4 {
                tolerance = tolerances[3]
            }
            else  {
                tolerance = tolerances[4]
            }
        }
        // Checks if it is a 6 band resistor for temperature.
        
        return "\(ohmsString) \(tolerance) \(temperature)"
        
        
    }
    
    func enableButtons(_ band: Int) {
        
        let tenDigits = Array(0...9)
        let twelveMultipliers = Array(0...11)
        let tolerance = [1,2,5,6,7,8,10,11]
        let tempCoeff = [1,2,3,4]
        
        let threeBand = [tenDigits,tenDigits,twelveMultipliers]
        let fourBand = [tenDigits,tenDigits,twelveMultipliers,tolerance]
        let fiveBand = [tenDigits,tenDigits,tenDigits,twelveMultipliers,tolerance]
        let sixBand = [tenDigits,tenDigits,tenDigits,twelveMultipliers,tolerance,tempCoeff]
        
        let resistors = [threeBand,fourBand,fiveBand,sixBand]
        
        let buttonNumbers = resistors[numBands-3]
        let bandOptions = buttonNumbers[band]
        
        disableButtons()
        for x in bandOptions {
            coloredButtons[x].isEnabled = true
        }
    }
    
    func disableButtons() {
        for button in coloredButtons {
            button.isEnabled = false
        }
    }
    
    @IBAction func colorsTouched(_ sender: UIButton) {
        currentBand += 1
        
        
        let uiViews = resistor.subviews
        let uiViewsNumbers = bandsForResistor[numBands]
        
        // if you want to reset by clicking the button a fourth time
        if currentBand == (numBands + 1) {
            colorsClicked.removeAll()
            colorsClicked.append(coloredButtons.firstIndex(of: sender)!)
            resetBands()
            currentBand = 1
            enableButtons(1)
            let bandToColor = uiViewsNumbers![currentBand-1]
            uiViews[bandToColor].backgroundColor = sender.backgroundColor
            print("You clicked color \(colorsClicked[0])")
        }
        else if currentBand == numBands {
            colorsClicked.append(coloredButtons.firstIndex(of: sender)!)
            let bandToColor = uiViewsNumbers![currentBand-1]
            uiViews[bandToColor].backgroundColor = sender.backgroundColor
            enableButtons(0)
            
        }
        else {
            colorsClicked.append(coloredButtons.firstIndex(of: sender)!)
            let bandToColor = uiViewsNumbers![currentBand - 1]
            uiViews[bandToColor].backgroundColor = sender.backgroundColor
            enableButtons(currentBand)

        }
        
        
        if colorsClicked.count == numBands {
            let answer = calculateAnswer(colorsClicked)
            print(answer)
            answerLabel.text = answer
        }
//        else {
//            print(colorsClicked.count)
//            print(colorsClicked)
//        }
        
        
    }
    
    
    
    
    func getCurrentBand() -> UIView {
        let viewers = resistor.subviews
        let numbers = bandsForResistor[numBands]
        let value = numbers?[Int(currentBand-1)]
        return viewers[value!]
    }
    
    
    
    @IBAction func backSpaceClicked(_ sender: UIButton) {
        if currentBand != 0 {
            getCurrentBand().backgroundColor = .cyan
            currentBand -= 1
            print("backspace clicked the current band is \(currentBand)")
            colorsClicked.removeLast()
            print("The colors clicked are \(colorsClicked)")
            
        }
        if currentBand == numBands-1 {
            answerLabel.text = ""
        }
        enableButtons(currentBand)
    }
    
    
    @IBAction func clearClicked(_ sender: UIButton) {
        resetBands()
        colorsClicked.removeAll()
        enableButtons(0)
    }
    
    
    func resetBands() {
        print("Your resistor has been reset")
        // make resistor cyan and get rid of text of answer
        for view in resistor.subviews {
            view.backgroundColor = .cyan
        }
        currentBand = 0
        answerLabel.text = ""
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetBands()
//        text.text = help
//        helpScrollView.isHidden = true
        // add segments to segmented control
        segmentedControl.removeAllSegments()
        for numBands in resistorBandOptions {
            segmentedControl.insertSegment(withTitle: String(numBands), at: resistorBandOptions.count, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        addButtons()
        coloredButtons[9].layer.borderColor = UIColor.black.cgColor
        coloredButtons[9].layer.borderWidth = 1
        enableButtons(0)
        
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textViewWidth.constant = CGFloat(round(Double(uiView.bounds.size.width * 0.75)))
        textViewHeight.constant = CGFloat(round(Double(uiView.bounds.size.height * 0.5)))
        textView.text = help
        textView.isHidden = true
        textView.isEditable = false
        
    }


}

