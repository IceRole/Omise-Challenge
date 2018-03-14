//
//  DonationViewController.swift
//  Omise-Challenge
//
//  Created by Shivam on 14/03/18.
//  Copyright © 2018 Omise. All rights reserved.
//

import UIKit

class DonationViewController: UIViewController, UITextFieldDelegate {
    var charityName:String = ""

    @IBOutlet weak var cardNumber: UITextField!
    
    @IBOutlet weak var amountTxtfield: UITextField!
    
    
    var selectedCardType: String? {
        didSet{
            reformatAsCardNumber(textField: self.cardNumber)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardNumber.addTarget(self, action: #selector(self.reformatAsCardNumber(textField:)), for: UIControlEvents.editingChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Selector to insert card details format
    @objc func reformatAsCardNumber(textField:UITextField){
        let formatter = CreditCardFormatter()
        var isAmex = false
        if selectedCardType == "AMEX" {
            isAmex = true
        }
        formatter.formatToCreditCardNumber(isAmex: isAmex, textField: textField, withPreviousTextContent: textField.text, andPreviousCursorPosition: textField.selectedTextRange)
    }

    //MARK: Submit details
    @IBAction func submitDetailsAction(_ sender: Any) {
        if self.cardNumber.text == "" || amountTxtfield.text == "" {
        showToast(withMessage: "Please fill all the details")
        return
        }
        let replaceStr = amountTxtfield.text?.replacingOccurrences(of: ",", with: "")
        let amountInt = Int(replaceStr!)

        if amountInt == 0 {
            showToast(withMessage: "Amount is not greater than 0")
        return
        }
    //Activity Trigger
        self.view.endEditing(true)
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        self.view.addSubview(actInd)
        actInd.startAnimating()
        
        //API Call
    ApiDataSource.sharedInstance.submitDonationDetails(self.charityName, token: self.cardNumber.text!, amount: amountInt!, completion:{
            result in
        DispatchQueue.main.async {

            self.showToast(withMessage: "Details submitted successfully.")
        actInd.stopAnimating()
        actInd.removeFromSuperview()
        }
        } )
        
    }
    
    //MARK: Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    
    }
    
    func showToast(withMessage message:String) {
        let menu = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(cancel)
        self.present(menu, animated: true, completion: nil)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Uses the number format corresponding to your Locale
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        
        
        // Uses the grouping separator corresponding to your Locale
        // e.g. "," in the US, a space in France, and so on
        if let groupingSeparator = formatter.groupingSeparator {
            
            if string == groupingSeparator {
                return true
            }
            
            
            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string == "" { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
                    
                    textField.text = formattedText
                    return false
                }
            }
        }
        return true
    }

}
