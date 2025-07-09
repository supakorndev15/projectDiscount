
//  ViewController.swift
import UIKit

// Coupon > On Top > Seasonal
class ViewController: UIViewController, UITextFieldDelegate {
    let viewModel = DiscountViewModel()
    var selectedItems: [Items] = []
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var sumPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var inputDiscountTextfield: UITextField!
    @IBOutlet weak var inputOnTopTextfield: UITextField!
    @IBOutlet weak var inputSeasonalTextfield: UITextField!
    @IBOutlet weak var inputPointsTextfield: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextfield.delegate = self
        inputDiscountTextfield.delegate = self
        inputOnTopTextfield.delegate = self
        inputSeasonalTextfield.delegate = self
        inputPointsTextfield.delegate = self
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
    
    
    // action เมื่อกด
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        viewModel.items = selectedItems
        viewModel.discounts.removeAll()
        
        // Coupon Discount (Fixed หรือ %)
        if let discountText = inputDiscountTextfield.text, !discountText.isEmpty {
            if discountText.contains("%") {
                let numberOnly = discountText.replacingOccurrences(of: "%", with: "")
                if let percent = Double(numberOnly) {
                    // percentageCoupon คิดเป็น %
                    viewModel.discounts.append(.percentageCoupon(percent: percent))
                }
            } else if let amount = Double(discountText) {
                // เป็จจำนวณเต็ม 
                viewModel.discounts.append(.fixedCoupon(amount: amount))
            }
        }

        // On Top Discount (Clothing only)
        // ลดแค่กลุ่ม clothing
        if let onTopText = inputOnTopTextfield.text,
           let percent = Double(onTopText) {
            // อยากลด กลุ่มไหน แก้ที่  category .
            viewModel.discounts.append(.categoryOnTop(category: .clothing, percent: percent))
        }

        // Points Discount (1 point = 1 THB, capped at 20%)
        if let pointText = inputPointsTextfield.text,
           let points = Int(pointText) {
            // ส่ง points เข้าไป Check ใน pointOnTop
            viewModel.discounts.append(.pointOnTop(point: points))
        }
        
//        Seasonal Discount (เช่น 300,40)
//        * Every X THB บาท
//        * Discount Y THB บาท
//        Discount: 40 THB at every 300 THB Total Price: 750
        
        if let seasonalText = inputSeasonalTextfield.text {
            // split จาก คอมม่า
            let parts = seasonalText.split(separator: ",")
            if parts.count == 2,
               let every = Double(parts[0]),
               let discount = Double(parts[1]) {
                viewModel.discounts.append(.seasonalDiscount(every: every, discount: discount))
            }
        }

        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        // ค่าที่ได้ไป แสดงใน Label
        updateFinalPrice()
    }

    
    // แยกฟังก์ชันคำนวณออกมาใช้งานซ้ำได้
    func updateFinalPrice() {
        
        let sumTotalBefore = viewModel.calculateTotalBeforeDiscount()
        sumPriceLabel.text = "ยอดก่อนลด: ฿\(String(format: "%.2f", sumTotalBefore))"
        print("sum : ฿\(String(format: "%.2f", sumTotalBefore))")
        
        let final = viewModel.calculateFinalPrice()
        finalPriceLabel.text = "฿\(String(format: "%.2f", final))"
        
        discountPriceLabel.text = ("ส่วนลด: ฿\(String(format: "%.2f", sumTotalBefore - final))")
        
        print("ราคาและส่วนลด: ฿\(String(format: "%.2f", final))")
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clearDiscountTextField()
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        clearDiscountTextField()
    }
    
    func clearDiscountTextField() {
        inputTextfield.text = ""
        inputDiscountTextfield.text = ""
        inputOnTopTextfield.text = ""
        inputSeasonalTextfield.text = ""
        inputPointsTextfield.text = ""
    }

}
