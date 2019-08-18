//
//  ViewController.swift
//  BitcoinChecker
//
//  Created by Dionte Silmon on 8/17/19.
//  Copyright © 2019 Dionte Silmon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    private let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    private let currencyArray = ["", "AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    private var finalURL = ""
    
    private var currencySymbolArray = ["", "$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    private var currencySelect = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UIPickerView delegate and dataSource
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row] // format the request
        
        currencySelect = currencySymbolArray[row] // Set the currency symbol
        
        getBitcoinData(url: finalURL) // call getBitcoinData
    }
    
    func getBitcoinData(url: String) {
        
        // Get the bitcoin data and check to see if the request was successful or not.
        Alamofire.request(url, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Got bitcoin data!")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            } else {
                print("Error: \(response.result.error!)")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    // Parse the json data.
    func updateBitcoinData(json: JSON) {
        
        // Check the bitcoin monthly price changes.
        if let bitcoinPrice = json["changes"]["price"]["month"].double {
            self.bitcoinPriceLabel.text = "\(currencySelect)\(bitcoinPrice)"
        } else {
            self.bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }

}

