import Foundation

// สร้าง Discount สำหรับเรียกใช้
enum Discount {
    case fixedCoupon(amount: Double) // fixedCoupon
    case percentageCoupon(percent: Double)
    case categoryOnTop(category: ItemCategory, percent: Double)
    case pointOnTop(point: Int)// ใช้ แต้ม
    case seasonalDiscount(every: Double, discount: Double) // ลดตามSeason Discount
}
