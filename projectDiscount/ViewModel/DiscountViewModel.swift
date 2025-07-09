
import Foundation

class DiscountViewModel {
    
    var items: [Items] = []
    var discounts: [Discount] = []
    
    func calculateFinalPrice() -> Double {
        // คำนวณราคารวมของสินค้าทั้งหมด
        let totalBeforeDiscount = items.reduce(0) { sum, item in
            return sum + item.price
        }
        
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
                let discountAmount = total * (percent / 100)
                total = total - discountAmount
            default:
                break
            }
        }
        
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
                // คำนวณราคารวมของสินค้าที่อยู่ใน category นั้น
                let categoryTotal = items.filter { item in
                    return item.category == category
                }.reduce(0) { sum, item in
                    return sum + item.price
                }
                
                let categoryDiscount = categoryTotal * (percent / 100)
                total = total - categoryDiscount
                
            case .pointOnTop(let points):
                // ใช้คะแนนลดได้ไม่เกิน 20% ของราคารวมปัจจุบัน
                let maxPointDiscount = total * 0.20
                let pointDiscount = min(Double(points), maxPointDiscount)
                total = total - pointDiscount
                
            default:
                break
            }
        }
        
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
}
