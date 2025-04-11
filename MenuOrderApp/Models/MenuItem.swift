import Foundation

struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var price: Double
    var imageName: String
    var category: Category
    var isPopular: Bool = false
    var ingredients: [String] = []
    var nutritionalInfo: NutritionalInfo?
    var allergens: [String] = []
    var preparationTimeMinutes: Int = 15
    
    // For dummy data preview
    static var previewItems: [MenuItem] {
        [
            MenuItem(name: "Classic Burger", 
                    description: "Juicy beef patty with lettuce, tomato, and special sauce", 
                    price: 9.99, 
                    imageName: "burger",
                    category: .mainDish,
                    isPopular: true,
                    ingredients: ["Beef patty", "Lettuce", "Tomato", "Onion", "Special sauce", "Brioche bun"],
                    nutritionalInfo: NutritionalInfo(calories: 650, protein: 35, carbs: 45, fat: 32),
                    allergens: ["Gluten", "Dairy"],
                    preparationTimeMinutes: 12),
            
            MenuItem(name: "Caesar Salad", 
                    description: "Fresh romaine lettuce with parmesan, croutons and Caesar dressing", 
                    price: 7.99, 
                    imageName: "salad",
                    category: .starter,
                    ingredients: ["Romaine lettuce", "Parmesan cheese", "Croutons", "Caesar dressing"],
                    nutritionalInfo: NutritionalInfo(calories: 320, protein: 10, carbs: 15, fat: 24),
                    allergens: ["Gluten", "Dairy", "Eggs"],
                    preparationTimeMinutes: 8),
            
            MenuItem(name: "Chocolate Cake", 
                    description: "Rich chocolate layer cake with ganache frosting", 
                    price: 6.99, 
                    imageName: "dessert",
                    category: .dessert,
                    isPopular: true,
                    ingredients: ["Chocolate", "Flour", "Sugar", "Eggs", "Butter", "Cream"],
                    nutritionalInfo: NutritionalInfo(calories: 450, protein: 5, carbs: 65, fat: 22),
                    allergens: ["Gluten", "Dairy", "Eggs"],
                    preparationTimeMinutes: 0),
            
            MenuItem(name: "Sparkling Water", 
                    description: "Refreshing carbonated water with a hint of lime", 
                    price: 2.99, 
                    imageName: "drink",
                    category: .beverage,
                    ingredients: ["Carbonated water", "Natural lime flavor"],
                    nutritionalInfo: NutritionalInfo(calories: 0, protein: 0, carbs: 0, fat: 0),
                    allergens: [],
                    preparationTimeMinutes: 0)
        ]
    }
}

struct NutritionalInfo: Hashable {
    var calories: Int
    var protein: Int // grams
    var carbs: Int // grams
    var fat: Int // grams
}

enum Category: String, CaseIterable, Identifiable, Hashable {
    case starter = "Starters"
    case mainDish = "Main Dishes"
    case sideDish = "Side Dishes"
    case dessert = "Desserts"
    case beverage = "Beverages"
    
    var id: String { self.rawValue }
    
    var imageName: String {
        switch self {
        case .starter: return "appetizer"
        case .mainDish: return "main"
        case .sideDish: return "side"
        case .dessert: return "dessert"
        case .beverage: return "drink"
        }
    }
}
