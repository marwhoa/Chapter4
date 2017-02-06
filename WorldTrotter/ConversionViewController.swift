//
//  ViewController.swift
//  WorldTrotter
//
//  Created by James Marlowe on 1/29/17.
//  Copyright © 2017 High Point University. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    var f_Value: Measurement<UnitTemperature>?{
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let f_Value = f_Value
        {
            return f_Value.converted(to: .celsius)
        }
        else
        {
            return nil
        }
    }
    
    func updateCelsiusLabel()
    {
        if let celsiusValue = celsiusValue
        {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }
        else
        {
            celsiusLabel.text = "???"
        }
    }
    
    /* Func textField
     * The text field calls this method on its delegate
     * This function prints the field's curent text, as well as the replacement string
     *
     */
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range : NSRange,
                   replacementString string: String) -> Bool
    {
        //print("Curent text: \(textField.text)")
        //print("Replacement text \(textField.text)")
        let digits = NSCharacterSet.decimalDigits //range of lower and uppercase letters
        
        //let customSet = NSCharacterSet.decimalDigits
        //customSet.formUnion(init(charactersIn: "))
        
        //below commented out to alow for Locales
        //let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        //let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        
        
        
        
        for code in string.utf8 { print(code) }
        //test if the range contains any letters
        //let hasExistingLetters = textField.text?.rangeOfCharacter(from: letters)
        let hasDigits = string.rangeOfCharacter(from: digits)
       
        
        if existingTextHasDecimalSeparator != nil,
            replacementTextHasDecimalSeparator != nil || hasDigits == nil
            
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    
    @IBAction func dismissKeyboard(_sender: UITapGestureRecognizer)
    {
        textField.resignFirstResponder()
    }
    
    @IBAction func fahrenheitFieldEditingChange(_ textField: UITextField)
    {
        //first, check is the text field has text
        //If so, check whether that text can be represented as a double
        if let text = textField.text, let number = numberFormatter.number(from: text)
        {
            f_Value = Measurement(value: number.doubleValue, unit: .fahrenheit)
        }
        else
        {
            f_Value = nil
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("ConversionViewController loaded its view")
        
        updateCelsiusLabel()
    }
}

