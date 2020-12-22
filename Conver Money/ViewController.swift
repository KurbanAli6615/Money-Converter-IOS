//
//  ViewController.swift
//  Conver Money
//
//  Created by KurbanAli on 18/12/20.
//
import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var p1: UIPickerView!
    @IBOutlet weak var p2: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    
    //    MARK:- GlobalVeriabls
    
    var baseUrl = "https://api.currencyfreaks.com/latest?apikey=8f30fc96402c475ba5ab8ce8892c383b&symbols="
    
    var allCurrencies = AllCurrencies.allCurrencies.sorted()
    
    var picker1:String = ""
    var picker2:String = ""
    var finalurl:String?
    
    
    //    MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        amountLabel.text = ""
        p1.delegate = self
        p1.dataSource = self
        p2.delegate = self
        p2.dataSource = self
        p1.tag = 1
        p2.tag = 2
    }
    
    @IBAction func convertMoney(_ sender: Any) {
        
        if (picker1 != "" && picker2 != ""){
            print(finalurl ?? "")
            amountLabel.text = ""
            if (self.amountTextField.text!.isEmpty){
                amountLabel.text = "Please Enter Amount"
            }
            else{
            getCurrencyDataFromCurrencyCode(url: finalurl!)
            }
        }
        else{
            amountLabel.text = "Select Both Picker"
        }
    }
    
    func getCurrencyDataFromCurrencyCode(url: String) {
        
        let request = AF.request(url)
        
        request.responseJSON { [self] (response) in

            guard response.error == nil else {
                print("Some Error has Occured")
                print(request.error?.localizedDescription ?? "")
                return
            }
            
            let dataFromApi:JSON = JSON(response.data!)
            
            if let rates = dataFromApi["rates"].dictionary {
                let from:Double = Double(rates[self.picker1]!.doubleValue)
                let to:Double = Double(rates[self.picker2]!.doubleValue)
                let baseAmount = Double(self.amountTextField.text!)
                
                convertCurrency(From: from, To: to, baseCurrencyAmount: baseAmount!)
                
            }
        }
    }
    func convertCurrency(From:Double, To:Double, baseCurrencyAmount:Double){
        
        amountLabel.text = String(format:"%.2f" ,baseCurrencyAmount * To / From)
    }
}

//  MARK:- Extension for Picker

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCurrencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            picker1 = allCurrencies[row]
        case 2:
            picker2 = allCurrencies[row]
        default:
            return
        }
        
        if (picker1 != "" && picker2 != ""){
            finalurl =  baseUrl + String(picker1) + "," + String(picker2)
        }
    }
}







