
import Foundation

struct Items {
    let name: String
    let category: ItemCategory
    let price: Double
}

enum ItemCategory: String {
    case clothing
    case accessories
    case electronics
}
