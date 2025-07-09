
//  ViewController.swift
import UIKit

// Coupon > On Top > Seasonal
class ViewController: UIViewController, UITextFieldDelegate {
    
    let viewModel = DiscountViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    let allItems: [Items] = [
        Items(name: "T-Shirt", category: .clothing, price: 350),
        Items(name: "Hat", category: .accessories, price: 250),
        Items(name: "Hoodie", category: .clothing, price: 700),
        Items(name: "Bag", category: .accessories, price: 640),
        Items(name: "Belt", category: .accessories, price: 230)
    ]
    
    var selectedItems: [Items] = []
    
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var inputDiscountTextfield: UITextField!
    @IBOutlet weak var inputOnTopTextfield: UITextField!
    @IBOutlet weak var inputSeasonalTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextfield.delegate = self
        inputDiscountTextfield.delegate = self
        inputOnTopTextfield.delegate = self
        inputSeasonalTextfield.delegate = self
        
        updateLabels()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func dropdownTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "เลือกสินค้า", message: nil, preferredStyle: .actionSheet)
        
        for item in allItems {
            let isSelected = selectedItems.contains(where: { $0.name == item.name })
            
            let title = isSelected ? "✓ \(item.name) - ฿\(Int(item.price))" : "\(item.name) - ฿\(Int(item.price))"
            
            let action = UIAlertAction(title: title, style: .default) { _ in
                if isSelected {
                    // ถ้าเลือกอยู่แล้ว กดซ้ำ = เอาออก
                    self.selectedItems.removeAll { $0.name == item.name }
                } else {
                    // ถ้ายังไม่เคยเลือก = เพิ่มเข้าไป
                    self.selectedItems.append(item)
                }
                self.updateLabels()
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        present(alert, animated: true)
    }
    
    func updateLabels() {
        labelStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in selectedItems.enumerated() {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 8
            
            let label = UILabel()
            label.text = "\(item.name) - ฿\(Int(item.price))"
            label.font = UIFont.systemFont(ofSize: 16)
            
            //สร้าง ปุ่ม ลบ
            let deleteButton = UIButton(type: .system)
            deleteButton.setTitle("ลบ", for: .normal)
            deleteButton.tag = index
            deleteButton.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
            
            hStack.addArrangedSubview(label)
            hStack.addArrangedSubview(deleteButton)
            
            labelStackView.addArrangedSubview(hStack)
        }
        viewModel.items = selectedItems
        updateFinalPrice()
    }
    
    @objc func removeItem(_ sender: UIButton) {
        let index = sender.tag
        guard index < selectedItems.count else { return }
        selectedItems.remove(at: index)
        updateLabels()
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
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        viewModel.items = selectedItems
        
        // เพิ่ม Discount จาก TextField ตามที่คุณใช้
        viewModel.discounts.removeAll()
        
        if let discountText = inputDiscountTextfield.text,
           let amount = Double(discountText) {
            viewModel.discounts.append(.fixedCoupon(amount: amount))
        }
        
        if let onTopText = inputOnTopTextfield.text,
           let percent = Double(onTopText) {
            viewModel.discounts.append(.categoryOnTop(category: .clothing, percent: percent))
        }
        
        if let seasonalText = inputSeasonalTextfield.text {
            let parts = seasonalText.split(separator: ",")
            if parts.count == 2,
               let every = Double(parts[0]),
               let discount = Double(parts[1]) {
                viewModel.discounts.append(.seasonalDiscount(every: every, discount: discount))
            }
        }
        
        let final = viewModel.calculateFinalPrice()
        finalPriceLabel.text = "Final: ฿\(String(format: "%.2f", final))"
        //        viewModel.items.removeAll()
        //        viewModel.discounts.removeAll()
        //
        //        // รับราคา
        //        if let priceText = inputTextfield.text,
        //           let price = Double(priceText) {
        //
        //            let newItem = Items(name: "T-Shirt", category: .clothing, price: price)
        //            viewModel.items.append(newItem)
        //
        //        } else {
        //            showAlert(title: "❌ ใส่ราคาสินค้าไม่ถูกต้อง", message: "กรุณาใส่ตัวเลข")
        //            return
        //        }
        //
        //        // รับ Fixed Discount
        //        if let discountText = inputDiscountTextfield.text,
        //           let discountAmount = Double(discountText) {
        //            viewModel.discounts.append(.fixedCoupon(amount: discountAmount))
        //        }
        //
        //        // รับ On Top (%)
        //        if let onTopText = inputOnTopTextfield.text,
        //           let onTopPercent = Double(onTopText) {
        //            viewModel.discounts.append(.categoryOnTop(category: .clothing, percent: onTopPercent))
        //        }
        //
        //        // รับ Seasonal (เช่น 300,40)
        //        if let seasonalText = inputSeasonalTextfield.text {
        //            let parts = seasonalText.split(separator: ",")
        //            if parts.count == 2,
        //               let every = Double(parts[0]),
        //               let discount = Double(parts[1]) {
        //                viewModel.discounts.append(.seasonalDiscount(every: every, discount: discount))
        //            }
        //        }
        //
        //        // คำนวณและแสดงผล
        //        let final = viewModel.calculateFinalPrice()
        //        finalPriceLabel.text = "ราคาหลังหักส่วนลดทั้งหมด: ฿\(String(format: "%.2f", final))"
    }
}

extension ViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInvalidPriceAlert() {
        let alert = UIAlertController(
            title: "❌ Invalid price input",
            message: "กรุณาใส่ตัวเลขที่ถูกต้องในช่องราคา",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
