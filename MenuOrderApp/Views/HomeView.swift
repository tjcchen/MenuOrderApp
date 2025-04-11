import SwiftUI

struct HomeView: View {
    @EnvironmentObject var menuDataStore: MenuDataStore
    @EnvironmentObject var userProfile: UserProfile
    @EnvironmentObject var order: Order
    
    @State private var searchText = ""
    @State private var selectedCategory: Category? = nil
    
    private var filteredItems: [MenuItem] {
        var items = menuDataStore.menuItems
        
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            items = items.filter { 
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
        
        return items
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hello, \(userProfile.isLoggedIn ? userProfile.name.components(separatedBy: " ").first ?? "Guest" : "Guest")")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("What would you like to order today?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for food...", text: $searchText)
                        .autocapitalization(.none)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        CategoryButton(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(Category.allCases) { category in
                            CategoryButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Popular Items
                if searchText.isEmpty && selectedCategory == nil {
                    VStack(alignment: .leading) {
                        Text("Popular Items")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(menuDataStore.menuItems.filter { $0.isPopular }) { item in
                                    NavigationLink(destination: MenuItemDetailView(item: item)) {
                                        PopularItemCard(item: item)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Menu Items
                LazyVStack(alignment: .leading, spacing: 20) {
                    Text(selectedCategory?.rawValue ?? (searchText.isEmpty ? "Menu" : "Search Results"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    if filteredItems.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("No items found")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                    } else {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: MenuItemDetailView(item: item)) {
                                MenuItemRow(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if item.id != filteredItems.last?.id {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .overlay(
            Group {
                if !order.items.isEmpty {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Text("\(order.items.count) items")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("$\(order.subtotal, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                        .onTapGesture {
                            // Navigate to cart
                        }
                    }
                }
            }
        )
    }
}

struct CategoryButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct PopularItemCard: View {
    let item: MenuItem
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 120)
                    .clipped()
                    .cornerRadius(8)
                
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(5)
            }
            
            Text(item.name)
                .font(.callout)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            Text(item.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(width: 160)
        .padding(.bottom, 5)
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(spacing: 15) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text("\(item.preparationTimeMinutes) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 2)
            }
            
            Button(action: {
                // Add to cart action would be here
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            .padding(.leading, 5)
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(MenuDataStore())
                .environmentObject(UserProfile.demoUser)
                .environmentObject(Order())
        }
    }
}
