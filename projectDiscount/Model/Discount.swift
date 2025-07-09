import Foundation

// สร้าง Discount สำหรับเรียกใช้
// ทำ กฏจะได้สร้างกฏอื่นๆได้
enum Discount {
    case fixedCoupon(amount: Double) // fixedCoupon
    case percentageCoupon(percent: Double) // percentageCoupon
    case categoryOnTop(category: ItemCategory, percent: Double)
    case pointOnTop(point: Int)// ใช้ แต้ม
    case seasonalDiscount(every: Double, discount: Double) // ลดตามSeason Discount
}
