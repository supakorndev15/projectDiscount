
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

// mock update เอง
let allItems: [Items] = [
    Items(name: "T-Shirt", category: .clothing, price: 350),
    Items(name: "Hat", category: .accessories, price: 250),
    Items(name: "Hoodie", category: .clothing, price: 700),
    Items(name: "Bag", category: .accessories, price: 640),
    Items(name: "Watch", category: .accessories, price: 850),
    Items(name: "Belt", category: .accessories, price: 230)
]
