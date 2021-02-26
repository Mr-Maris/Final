//
//  TaxVC.swift
//  SwiftVsSwift
//
//  Created by Maris Rasnacs on 26/02/2021.
//

import UIKit

class TaxVC: UIViewController {
    
    @IBOutlet weak var PriceTxt: UITextField!
    @IBOutlet weak var SalesTaxtxt: UITextField!
    @IBOutlet weak var totalPricelbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPricelbl.text = ""
    }
    
    @IBAction func calculateTotalPrice(_ sender: Any) {
        let price = Double(PriceTxt.text!)!
        let salesTax = Double(SalesTaxtxt.text!)!
        
        let totalSalesTax = price * salesTax/100
        let totalPrice = price + totalSalesTax
        totalPricelbl.text = "Eur \(totalPrice)"
    }
    
}
