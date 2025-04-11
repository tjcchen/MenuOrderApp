import Foundation
import SwiftUI

struct OrderItem: Identifiable, Hashable {
    var id = UUID()
    var menuItem: MenuItem
    var quantity: Int = 1
    var specialInstructions: String = ""
    
    var totalPrice: Double {
        return menuItem.price * Double(quantity)
    }
}

class Order: ObservableObject {
    @Published var items: [OrderItem] = []
    @Published var deliveryAddress: Address? = nil
    @Published var paymentMethod: PaymentMethod? = nil
    @Published var deliveryTime: Date? = nil
    @Published var orderStatus: OrderStatus = .cart
    @Published var specialInstructions: String = ""
    @Published var orderNumber: String = ""
    @Published var estimatedDeliveryTime: Int = 30 // minutes
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var tax: Double {
        subtotal * 0.08 // 8% tax
    }
    
    var deliveryFee: Double {
        items.isEmpty ? 0 : 3.99
    }
    
    var total: Double {
        subtotal + tax + deliveryFee
    }
    
    func addItem(_ item: MenuItem, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.menuItem.id == item.id }) {
            items[index].quantity += quantity
        } else {
            items.append(OrderItem(menuItem: item, quantity: quantity))
        }
    }
    
    func removeItem(_ item: OrderItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(for item: OrderItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity = max(1, quantity)
        }
    }
    
    func clearCart() {
        items.removeAll()
        specialInstructions = ""
    }
    
    func checkout() -> Bool {
        // In a real app, this would make an API call to process the order
        guard !items.isEmpty, deliveryAddress != nil, paymentMethod != nil else {
            return false
        }
        
        orderStatus = .preparing
        orderNumber = generateOrderNumber()
        return true
    }
    
    private func generateOrderNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmm"
        let dateString = dateFormatter.string(from: Date())
        let randomDigits = String(format: "%04d", Int.random(in: 0...9999))
        return "#\(dateString)\(randomDigits)"
    }
}

enum OrderStatus: String, CaseIterable {
    case cart = "Cart"
    case preparing = "Preparing"
    case readyForPickup = "Ready for Pickup"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"
    case completed = "Completed"
    
    var systemImage: String {
        switch self {
        case .cart: return "cart"
        case .preparing: return "clock"
        case .readyForPickup: return "bag.fill"
        case .outForDelivery: return "bicycle"
        case .delivered: return "checkmark.circle"
        case .completed: return "star.fill"
        }
    }
}

struct Address: Hashable {
    var street: String
    var apartment: String
    var city: String
    var state: String
    var zipCode: String
    var isSavedAddress: Bool = false
    var label: String = "Home"
    
    var formattedAddress: String {
        var formatted = street
        if !apartment.isEmpty {
            formatted += ", \(apartment)"
        }
        formatted += ", \(city), \(state) \(zipCode)"
        return formatted
    }
}

enum PaymentMethod: String, CaseIterable, Identifiable {
    case applePay = "Apple Pay"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case paypal = "PayPal"
    
    var id: String { self.rawValue }
    
    var systemImage: String {
        switch self {
        case .applePay: return "apple.logo"
        case .creditCard, .debitCard: return "creditcard"
        case .paypal: return "p.circle"
        }
    }
}
