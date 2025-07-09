
import Foundation

// ส่วนการคิด Logic
class DiscountViewModel {
    
    var items: [Items] = []
    var discounts: [Discount] = []
    
    func calculateFinalPrice() -> Double {
        // คำนวณราคารวมของสินค้าทั้งหมด
        let totalBeforeDiscount = items.reduce(0) { sum, item in
            return sum + item.price
        }
        
        // var totalBeforeDiscount = 0.0
//        for item in items {
//            totalBeforeDiscount += item.price
//        }

        var total = totalBeforeDiscount
        
        // 1. ตรวจสอบว่ามีส่วนลดประเภท Coupon หรือไม่
        let couponDiscount = discounts.first { discount in
            switch discount {
            case .fixedCoupon, .percentageCoupon:
                return true
            default:
                return false
            }
        }
        
        // ใช้ส่วนลด Coupon ถ้ามี
        if let coupon = couponDiscount {
            switch coupon {
            case .fixedCoupon(let amount):
                total = total - amount
            case .percentageCoupon(let percent):
                let discountAmount = total * (percent / 100) // หาส่วนลด
                total = total - discountAmount
            default:
                break
            }
        }
        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        // 2. ตรวจสอบส่วนลดประเภท On Top
        let onTopDiscount = discounts.first { discount in
            switch discount {
            case .categoryOnTop, .pointOnTop:
                return true
            default:
                return false
            }
        }
        
        // ใช้ On Top Discount ถ้ามี
        if let onTop = onTopDiscount {
            switch onTop {
            case .categoryOnTop(let category, let percent):
                // คำนวณราคา รวมของสินค้าที่อยู่ใน category
                let categoryTotal = items.filter { item in
                    return item.category == category
                }.reduce(0) { sum, item in
                    return sum + item.price
                }
                
                let categoryDiscount = categoryTotal * (percent / 100)
                total = total - categoryDiscount
                
            case .pointOnTop(let points):
                // ใช้คะแนนลดได้ไม่เกิน 20% ของราคารวมปัจจุบัน
                // Noted that “20%” is fixed rule เลยแปลงค่าเป็น 0.20
                let maxPointDiscount = total * 0.20
                let pointDiscount = min(Double(points), maxPointDiscount)
                total = total - pointDiscount
                
            default:
                break
            }
        }
        
        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        // 3. ตรวจสอบ Seasonal Discount
        let seasonalDiscount = discounts.first { discount in
            switch discount {
            case .seasonalDiscount:
                return true
            default:
                return false
            }
        }
        
        // ใช้ Seasonal Discount ถ้ามี
        if let seasonal = seasonalDiscount {
            switch seasonal {
            case .seasonalDiscount(let everyAmount, let discountPerUnit):
                let numberOfUnits = Int(total / everyAmount)
                let seasonalDiscountAmount = Double(numberOfUnits) * discountPerUnit
                total = total - seasonalDiscountAmount
            default:
                break
            }
        }
        
        // ตรวจสอบว่าผลลัพธ์ไม่ติดลบ
        return max(total, 0)
    }
    
    
    // แค่อยากส้ง totalBeforeDiscount ออกไป แสดง
    func calculateTotalBeforeDiscount() -> Double {
        let totalBeforeDiscount = items.reduce(0) { sum, item in
            return sum + item.price
        }
        return totalBeforeDiscount
//        return items.reduce(0) { $0 + $1.price }
    }
}
