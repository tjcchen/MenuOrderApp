import SwiftUI

struct MenuItemDetailView: View {
    let item: MenuItem
    @EnvironmentObject var order: Order
    @EnvironmentObject var userProfile: UserProfile
    @State private var quantity: Int = 1
    @State private var specialInstructions: String = ""
    @State private var showingAddedToCart = false
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero image
                ZStack(alignment: .topTrailing) {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                    
                    HStack {
                        Button(action: {
                            isFavorite.toggle()
                            if isFavorite {
                                userProfile.addToFavorites(item)
                            } else {
                                userProfile.removeFromFavorites(item)
                            }
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isFavorite ? .red : .white)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.5))
                                )
                        }
                    }
                    .padding()
                }
                
                // Item details
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("$\(item.price, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                    
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Preparation time
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        
                        Text("Preparation Time: \(item.preparationTimeMinutes) min")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Ingredients
                    if !item.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                            
                            ForEach(item.ingredients, id: \.self) { ingredient in
                                HStack(alignment: .top) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.secondary)
                                        .padding(.top, 7)
                                    
                                    Text(ingredient)
                                        .font(.subheadline)
                                }
                            }
                        }
                        
                        Divider()
                    }
                    
                    // Nutritional info
                    if let nutrition = item.nutritionalInfo {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutritional Information")
                                .font(.headline)
                            
                            HStack(spacing: 15) {
                                NutritionInfoItem(value: nutrition.calories, unit: "cal", icon: "flame.fill")
                                NutritionInfoItem(value: nutrition.protein, unit: "g protein", icon: "p.circle.fill")
                                NutritionInfoItem(value: nutrition.carbs, unit: "g carbs", icon: "c.circle.fill")
                                NutritionInfoItem(value: nutrition.fat, unit: "g fat", icon: "f.circle.fill")
                            }
                        }
                        
                        Divider()
                    }
                    
                    // Allergens
                    if !item.allergens.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Allergen Information")
                                .font(.headline)
                            
                            Text("Contains: \(item.allergens.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                    }
                    
                    // Special instructions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Special Instructions")
                            .font(.headline)
                        
                        TextField("Any special requests?", text: $specialInstructions)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Quantity selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quantity")
                            .font(.headline)
                        
                        HStack {
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            }
                            
                            Text("\(quantity)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(width: 40)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                quantity += 1
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            }
                            
                            Spacer()
                            
                            Text("$\(item.price * Double(quantity), specifier: "%.2f")")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isFavorite = userProfile.favoriteItems.contains(where: { $0.id == item.id })
        }
        .overlay(
            Button(action: {
                let orderItem = OrderItem(menuItem: item, quantity: quantity, specialInstructions: specialInstructions)
                order.addItem(item, quantity: quantity)
                showingAddedToCart = true
            }) {
                Text("Add to Cart - $\(item.price * Double(quantity), specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .padding(.bottom, 20)
            .opacity(showingAddedToCart ? 0 : 1)
            .animation(.easeInOut, value: showingAddedToCart)
            .disabled(showingAddedToCart)
            , alignment: .bottom
        )
        .overlay(
            Group {
                if showingAddedToCart {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 15) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                            
                            Text("Added to Cart!")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Button(action: {
                                    showingAddedToCart = false
                                }) {
                                    Text("Continue Shopping")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.accentColor)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.accentColor, lineWidth: 1)
                                        )
                                }
                                
                                Button(action: {
                                    // Navigate to cart
                                }) {
                                    Text("View Cart")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 30)
                                        .background(Color.accentColor)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                    .transition(.opacity)
                }
            }
        )
    }
}

struct NutritionInfoItem: View {
    let value: Int
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuItemDetailView(item: MenuItem.previewItems[0])
                .environmentObject(Order())
                .environmentObject(UserProfile())
        }
    }
}
