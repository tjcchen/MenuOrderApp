import Foundation
import SwiftUI
import Combine

class MenuDataStore: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // In a real app, we would fetch from an API
        // For demo purposes, we'll use our sample data
        loadSampleData()
    }
    
    func loadSampleData() {
        self.isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.menuItems = MenuItem.previewItems
            
            // Add more items to the sample data to create a more comprehensive menu
            self.menuItems += self.generateMoreMenuItems()
            self.isLoading = false
        }
    }
    
    // Generate additional menu items
    private func generateMoreMenuItems() -> [MenuItem] {
        return [
            MenuItem(name: "Margherita Pizza",
                    description: "Classic pizza with tomato sauce, mozzarella, and basil",
                    price: 12.99,
                    imageName: "burger", // Using existing image for demo
                    category: .mainDish,
                    isPopular: true,
                    ingredients: ["Pizza dough", "Tomato sauce", "Mozzarella cheese", "Fresh basil", "Olive oil"],
                    nutritionalInfo: NutritionalInfo(calories: 780, protein: 25, carbs: 90, fat: 35),
                    allergens: ["Gluten", "Dairy"],
                    preparationTimeMinutes: 18),
            
            MenuItem(name: "Greek Salad",
                    description: "Fresh salad with cucumber, tomato, olives, and feta cheese",
                    price: 8.99,
                    imageName: "salad", // Using existing image for demo
                    category: .starter,
                    ingredients: ["Cucumber", "Tomato", "Red onion", "Kalamata olives", "Feta cheese", "Olive oil", "Oregano"],
                    nutritionalInfo: NutritionalInfo(calories: 280, protein: 8, carbs: 12, fat: 22),
                    allergens: ["Dairy"],
                    preparationTimeMinutes: 10),
            
            MenuItem(name: "Chicken Wings",
                    description: "Crispy wings tossed in your choice of sauce",
                    price: 10.99,
                    imageName: "burger", // Using existing image for demo
                    category: .starter,
                    isPopular: true,
                    ingredients: ["Chicken wings", "Flour", "Spices", "Buffalo sauce"],
                    nutritionalInfo: NutritionalInfo(calories: 450, protein: 30, carbs: 15, fat: 28),
                    allergens: ["Gluten"],
                    preparationTimeMinutes: 15),
            
            MenuItem(name: "French Fries",
                    description: "Crispy golden fries served with ketchup",
                    price: 4.99,
                    imageName: "salad", // Using existing image for demo
                    category: .sideDish,
                    ingredients: ["Potatoes", "Vegetable oil", "Salt"],
                    nutritionalInfo: NutritionalInfo(calories: 320, protein: 4, carbs: 42, fat: 16),
                    allergens: [],
                    preparationTimeMinutes: 8),
            
            MenuItem(name: "Chocolate Milkshake",
                    description: "Rich and creamy chocolate milkshake with whipped cream",
                    price: 5.99,
                    imageName: "drink", // Using existing image for demo
                    category: .beverage,
                    ingredients: ["Milk", "Chocolate ice cream", "Chocolate syrup", "Whipped cream"],
                    nutritionalInfo: NutritionalInfo(calories: 520, protein: 9, carbs: 68, fat: 25),
                    allergens: ["Dairy"],
                    preparationTimeMinutes: 5),
            
            MenuItem(name: "Apple Pie",
                    description: "Warm apple pie with a flaky crust and cinnamon",
                    price: 6.99,
                    imageName: "dessert", // Using existing image for demo
                    category: .dessert,
                    ingredients: ["Apples", "Flour", "Sugar", "Butter", "Cinnamon", "Nutmeg"],
                    nutritionalInfo: NutritionalInfo(calories: 380, protein: 3, carbs: 55, fat: 18),
                    allergens: ["Gluten", "Dairy"],
                    preparationTimeMinutes: 0),
            
            MenuItem(name: "Caprese Sandwich",
                    description: "Fresh mozzarella, tomato, and basil on ciabatta bread",
                    price: 9.99,
                    imageName: "burger", // Using existing image for demo
                    category: .mainDish,
                    ingredients: ["Ciabatta bread", "Fresh mozzarella", "Tomato", "Basil", "Balsamic glaze", "Olive oil"],
                    nutritionalInfo: NutritionalInfo(calories: 420, protein: 18, carbs: 40, fat: 22),
                    allergens: ["Gluten", "Dairy"],
                    preparationTimeMinutes: 10),
            
            MenuItem(name: "Iced Tea",
                    description: "Refreshing iced tea with lemon",
                    price: 3.49,
                    imageName: "drink", // Using existing image for demo
                    category: .beverage,
                    ingredients: ["Black tea", "Water", "Lemon", "Sugar"],
                    nutritionalInfo: NutritionalInfo(calories: 80, protein: 0, carbs: 20, fat: 0),
                    allergens: [],
                    preparationTimeMinutes: 0)
        ]
    }
    
    // Get menu items for a specific category
    func getItems(for category: Category) -> [MenuItem] {
        return menuItems.filter { $0.category == category }
    }
    
    // Get popular menu items
    func getPopularItems() -> [MenuItem] {
        return menuItems.filter { $0.isPopular }
    }
    
    // Search menu items
    func searchItems(query: String) -> [MenuItem] {
        guard !query.isEmpty else { return menuItems }
        
        let lowercasedQuery = query.lowercased()
        return menuItems.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery) ||
            $0.category.rawValue.lowercased().contains(lowercasedQuery)
        }
    }
}
