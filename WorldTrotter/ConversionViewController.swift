//
//  ViewController.swift
//  WorldTrotter
//
//  Created by James Marlowe on 1/29/17.
//  Copyright © 2017 High Point University. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
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
            celsiusLabel.text = "\(celsiusValue.value)"
        }
        else
        {
            celsiusLabel.text = "???"
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
        if let text = textField.text, let value = Double(text)
        {
            f_Value = Measurement(value: value, unit: .fahrenheit)
        }
        else
        {
            f_Value = nil
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateCelsiusLabel()
    }
}

