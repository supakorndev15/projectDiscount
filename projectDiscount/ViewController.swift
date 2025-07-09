//
//  ViewController.swift
//  projectDiscount

// test 
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateDiscount()
    }

    func calculateDiscount() {
        let cart = [
            Item(name: "T-Shirt", category: .clothing, price: 350),
            Item(name: "Hat", category: .accessories, price: 250),
            Item(name: "Belt", category: .accessories, price: 230)
        ]

        let campaigns: [Campaign] = [
            Campaign(type: .percentage(percent: 10), group: .coupon),
            Campaign(type: .pointDiscount(points: 68), group: .onTop),
            Campaign(type: .seasonalDiscount(everyX: 300, discountY: 40), group: .seasonal)
        ]

        let calculator = DiscountCalculator()
        let finalPrice = calculator.applyDiscounts(cart: cart, campaigns: campaigns)
        print("Final price: \(finalPrice) THB")
        
        txtLabel.text = "Final price: \(finalPrice) THB"
    }
}


