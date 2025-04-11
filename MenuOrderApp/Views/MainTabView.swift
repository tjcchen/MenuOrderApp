import SwiftUI

struct MainTabView: View {
    @StateObject private var menuDataStore = MenuDataStore()
    @StateObject private var userProfile = UserProfile()
    @StateObject private var order = Order()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            NavigationView {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "cart")
            }
            .tag(1)
            .badge(order.items.isEmpty ? nil : "\(order.items.count)")
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(2)
        }
        .accentColor(.accentColor)
        .environmentObject(menuDataStore)
        .environmentObject(userProfile)
        .environmentObject(order)
        .onAppear {
            // Set the default appearance for tab bar
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // For iOS 15 navigation bar
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
            
            // Load menu data
            menuDataStore.loadSampleData()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
