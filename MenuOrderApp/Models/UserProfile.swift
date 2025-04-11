import Foundation
import SwiftUI

class UserProfile: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var savedAddresses: [Address] = []
    @Published var favoriteItems: [MenuItem] = []
    @Published var orderHistory: [HistoricalOrder] = []
    @Published var preferredPaymentMethod: PaymentMethod?
    @Published var notifications: Bool = true
    @Published var specialOffers: Bool = true
    @Published var isDarkMode: Bool = false
    @Published var loyaltyPoints: Int = 0
    
    var isLoggedIn: Bool {
        !name.isEmpty && !email.isEmpty
    }
    
    func addToFavorites(_ item: MenuItem) {
        if !favoriteItems.contains(where: { $0.id == item.id }) {
            favoriteItems.append(item)
        }
    }
    
    func removeFromFavorites(_ item: MenuItem) {
        favoriteItems.removeAll { $0.id == item.id }
    }
    
    func saveAddress(_ address: Address) {
        if !savedAddresses.contains(where: { $0.formattedAddress == address.formattedAddress }) {
            var newAddress = address
            newAddress.isSavedAddress = true
            savedAddresses.append(newAddress)
        }
    }
    
    func removeAddress(_ address: Address) {
        savedAddresses.removeAll { $0.formattedAddress == address.formattedAddress }
    }
    
    func addOrderToHistory(_ order: Order) {
        let historicalOrder = HistoricalOrder(
            items: order.items,
            orderNumber: order.orderNumber,
            orderDate: Date(),
            total: order.total,
            deliveryAddress: order.deliveryAddress,
            status: order.orderStatus
        )
        orderHistory.append(historicalOrder)
        
        // Add loyalty points for the order
        loyaltyPoints += Int(order.subtotal / 10) // 1 point for every $10 spent
    }
    
    // For demo/preview purposes
    static var demoUser: UserProfile {
        let user = UserProfile()
        user.name = "John Doe"
        user.email = "john.doe@example.com"
        user.phoneNumber = "555-123-4567"
        user.savedAddresses = [
            Address(street: "123 Main St", apartment: "Apt 4B", city: "San Francisco", state: "CA", zipCode: "94105", isSavedAddress: true, label: "Home"),
            Address(street: "456 Market St", apartment: "", city: "San Francisco", state: "CA", zipCode: "94103", isSavedAddress: true, label: "Work")
        ]
        user.preferredPaymentMethod = .applePay
        
        // Add some favorite items
        MenuItem.previewItems.forEach { item in
            if item.isPopular {
                user.favoriteItems.append(item)
            }
        }
        
        // Add some order history
        let pastOrder1 = HistoricalOrder(
            items: [OrderItem(menuItem: MenuItem.previewItems[0], quantity: 2)],
            orderNumber: "#2504080123",
            orderDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            total: 23.96,
            deliveryAddress: user.savedAddresses[0],
            status: .completed
        )
        
        let pastOrder2 = HistoricalOrder(
            items: [
                OrderItem(menuItem: MenuItem.previewItems[1], quantity: 1),
                OrderItem(menuItem: MenuItem.previewItems[3], quantity: 2)
            ],
            orderNumber: "#2503150847",
            orderDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            total: 15.97,
            deliveryAddress: user.savedAddresses[1],
            status: .completed
        )
        
        user.orderHistory = [pastOrder1, pastOrder2]
        user.loyaltyPoints = 45
        
        return user
    }
}

struct HistoricalOrder: Identifiable, Hashable {
    var id = UUID()
    var items: [OrderItem]
    var orderNumber: String
    var orderDate: Date
    var total: Double
    var deliveryAddress: Address?
    var status: OrderStatus
    
    static func == (lhs: HistoricalOrder, rhs: HistoricalOrder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
