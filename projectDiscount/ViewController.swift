
//  ViewController.swift
import UIKit

// Coupon > On Top > Seasonal
class ViewController: UIViewController, UITextFieldDelegate {
    
    let viewModel = DiscountViewModel()
    
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var inputTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextfield.delegate = self
        
        // ตัวอย่างทดสอบ
        viewModel.items = [
            Items(name: "T-Shirt", category: .clothing, price: 350),
            Items(name: "Hat", category: .accessories, price: 250)
        ]
        viewModel.discounts = [
            .fixedCoupon(amount: 50),
            .categoryOnTop(category: .clothing, percent: 15),
            .seasonalDiscount(every: 300, discount: 40)
        ]
        
        updateFinalPrice()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // แยกฟังก์ชันคำนวณออกมาใช้งานซ้ำได้
    func updateFinalPrice() {
        let final = viewModel.calculateFinalPrice()
        finalPriceLabel.text = "Final: ฿\(String(format: "%.2f", final))"
        print("Final: ฿\(String(format: "%.2f", final))")
    }
    
    @IBAction func addItemTapped(_ sender: UIButton) {
        if let priceText = inputTextfield.text,
           let price = Double(priceText) {
            
            let newItem = Items(name: "T-Shirt", category: .clothing, price: price)
            viewModel.items.append(newItem)
            
            // คำนวณราคาใหม่
            updateFinalPrice()
            
        } else {
            // แสดงข้อความเตือนผู้ใช้
            showInvalidPriceAlert()
            print("❌ Invalid price input: กรุณาใส่ตัวเลข")
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension ViewController {
    func showInvalidPriceAlert() {
        let alert = UIAlertController(
            title: "❌ Invalid price input",
            message: "กรุณาใส่ตัวเลขที่ถูกต้องในช่องราคา",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true, completion: nil)
    }

}
