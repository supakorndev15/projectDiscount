//
//  DiscountModel.swift
//  projectDiscount
//
//  Created by MacDetail on 3/7/2568 BE.
//

import Foundation

enum Category: String {
    case clothing, accessories, electronics
}

struct Item {
    let name: String
    let category: Category
    let price: Double
}

enum DiscountCampaignType {
    case fixedAmount(amount: Double)
    case percentage(percent: Double)
    case categoryDiscount(category: Category, percent: Double)
    case pointDiscount(points: Int)
    case seasonalDiscount(everyX: Double, discountY: Double)
}

enum CampaignGroup {
    case coupon
    case onTop
    case seasonal
}

struct Campaign {
    let type: DiscountCampaignType
    let group: CampaignGroup
}

class DiscountCalculator {
    
    func applyDiscounts(cart: [Item], campaigns: [Campaign]) -> Double {
        var total = cart.reduce(0) { $0 + $1.price }
        
        let grouped = Dictionary(grouping: campaigns, by: { $0.group })

        if let coupon = grouped[.coupon]?.first {
            total = applyCoupon(total: total, campaign: coupon)
        }

        if let onTop = grouped[.onTop]?.first {
            total = applyOnTop(total: total, cart: cart, campaign: onTop)
        }

        if let seasonal = grouped[.seasonal]?.first {
            total = applySeasonal(total: total, campaign: seasonal)
        }

        return max(0, round(total * 100) / 100)
    }

    private func applyCoupon(total: Double, campaign: Campaign) -> Double {
        switch campaign.type {
        case .fixedAmount(let amount):
            return total - amount
        case .percentage(let percent):
            return total * (1 - percent / 100.0)
        default:
            return total
        }
    }

    private func applyOnTop(total: Double, cart: [Item], campaign: Campaign) -> Double {
        switch campaign.type {
        case .categoryDiscount(let category, let percent):
            let discountable = cart.filter { $0.category == category }.reduce(0) { $0 + $1.price }
            return total - discountable * (percent / 100.0)
        case .pointDiscount(let points):
            let maxDiscount = total * 0.20
            return total - min(Double(points), maxDiscount)
        default:
            return total
        }
    }

    private func applySeasonal(total: Double, campaign: Campaign) -> Double {
        switch campaign.type {
        case .seasonalDiscount(let everyX, let discountY):
            let units = floor(total / everyX)
            return total - units * discountY
        default:
            return total
        }
    }
}
