import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userProfile: UserProfile
    @State private var isEditing = false
    @State private var showingLoginForm = false
    @State private var tempProfile = UserProfile()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Profile Header
                profileHeader
                
                if userProfile.isLoggedIn {
                    // User details section
                    userDetailsSection
                    
                    // Loyalty points
                    loyaltyPointsSection
                    
                    // Order history
                    orderHistorySection
                    
                    // Favorites
                    favoritesSection
                    
                    // Settings
                    settingsSection
                    
                    // Logout
                    logoutButton
                } else {
                    // Login prompt
                    loginPrompt
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showingLoginForm) {
            LoginView()
        }
        .sheet(isPresented: $isEditing) {
            EditProfileView(profile: $tempProfile) { updatedProfile in
                userProfile.name = updatedProfile.name
                userProfile.email = updatedProfile.email
                userProfile.phoneNumber = updatedProfile.phoneNumber
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                if userProfile.isLoggedIn {
                    Text(String(userProfile.name.prefix(1).uppercased()))
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.accentColor)
                }
            }
            
            if userProfile.isLoggedIn {
                Text(userProfile.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(userProfile.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Guest User")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    private var userDetailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Personal Information")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    tempProfile = userProfile
                    isEditing = true
                }) {
                    Text("Edit")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            Divider()
            
            InfoRow(icon: "person.fill", title: "Name", value: userProfile.name)
            InfoRow(icon: "envelope.fill", title: "Email", value: userProfile.email)
            
            if !userProfile.phoneNumber.isEmpty {
                InfoRow(icon: "phone.fill", title: "Phone", value: userProfile.phoneNumber)
            }
            
            // Saved addresses
            if !userProfile.savedAddresses.isEmpty {
                Text("Saved Addresses")
                    .font(.headline)
                    .padding(.top, 10)
                
                Divider()
                
                ForEach(userProfile.savedAddresses, id: \.formattedAddress) { address in
                    InfoRow(icon: "location.fill", title: address.label, value: address.formattedAddress)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var loyaltyPointsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Loyalty Program")
                .font(.headline)
            
            Divider()
            
            HStack(alignment: .center, spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(userProfile.loyaltyPoints) Points")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Earn 1 point for every $10 spent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    // View rewards action
                }) {
                    Text("View Rewards")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var orderHistorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Order History")
                .font(.headline)
            
            Divider()
            
            if userProfile.orderHistory.isEmpty {
                HStack {
                    Spacer()
                    Text("No orders yet")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                    Spacer()
                }
            } else {
                ForEach(userProfile.orderHistory.prefix(3)) { order in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(order.orderNumber)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(formatDate(order.orderDate))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("\(order.items.count) items")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("$\(order.total, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack {
                            Text("Status: \(order.status.rawValue)")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(statusBackgroundColor(for: order.status))
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            
                            Spacer()
                            
                            Button(action: {
                                // View order details
                            }) {
                                Text("Details")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    if order.id != userProfile.orderHistory.prefix(3).last?.id {
                        Divider()
                    }
                }
                
                if userProfile.orderHistory.count > 3 {
                    Button(action: {
                        // View all orders
                    }) {
                        Text("View All Orders")
                            .font(.callout)
                            .foregroundColor(.accentColor)
                            .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Favorite Items")
                .font(.headline)
            
            Divider()
            
            if userProfile.favoriteItems.isEmpty {
                HStack {
                    Spacer()
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                    Spacer()
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(userProfile.favoriteItems) { item in
                            VStack(alignment: .leading) {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 80)
                                    .cornerRadius(8)
                                
                                Text(item.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                
                                Text("$\(item.price, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                            .frame(width: 100)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Settings")
                .font(.headline)
            
            Divider()
            
            Toggle("Push Notifications", isOn: $userProfile.notifications)
                .font(.subheadline)
            
            Toggle("Special Offers", isOn: $userProfile.specialOffers)
                .font(.subheadline)
            
            Toggle("Dark Mode", isOn: $userProfile.isDarkMode)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var logoutButton: some View {
        Button(action: {
            // Logout action
            // This is just a simple reset for demo purposes
            let savedAddresses = userProfile.savedAddresses
            let isDarkMode = userProfile.isDarkMode
            
            // Reset user profile
            userProfile.name = ""
            userProfile.email = ""
            userProfile.phoneNumber = ""
            userProfile.favoriteItems = []
            userProfile.orderHistory = []
            userProfile.preferredPaymentMethod = nil
            userProfile.loyaltyPoints = 0
            
            // Preserve addresses and settings
            userProfile.savedAddresses = savedAddresses
            userProfile.isDarkMode = isDarkMode
        }) {
            Text("Logout")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
        }
    }
    
    private var loginPrompt: some View {
        VStack(spacing: 20) {
            Text("Sign in to access your profile, track orders, and earn loyalty points!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showingLoginForm = true
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Helper functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func statusBackgroundColor(for status: OrderStatus) -> Color {
        switch status {
        case .cart: return .gray
        case .preparing: return .orange
        case .readyForPickup: return .blue
        case .outForDelivery: return .purple
        case .delivered, .completed: return .green
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 5)
    }
}

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userProfile: UserProfile
    
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(isSignUp ? "Create an Account" : "Sign In")) {
                    if isSignUp {
                        TextField("Full Name", text: $name)
                            .autocapitalization(.words)
                    }
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    if isSignUp {
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }
                }
                
                Section {
                    Button(action: {
                        if isSignUp {
                            // Sign up action
                            signUp()
                        } else {
                            // Sign in action
                            signIn()
                        }
                    }) {
                        Text(isSignUp ? "Create Account" : "Sign In")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                }
                
                Section {
                    Button(action: {
                        withAnimation {
                            isSignUp.toggle()
                            errorMessage = ""
                            showError = false
                        }
                    }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle(isSignUp ? "Create Account" : "Sign In")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func signIn() {
        // Simplified sign in for demo
        if email.isEmpty {
            errorMessage = "Please enter your email"
            showError = true
            return
        }
        
        // For demo purposes, we'll use the demo user
        let demoUser = UserProfile.demoUser
        userProfile.name = demoUser.name
        userProfile.email = email
        userProfile.phoneNumber = demoUser.phoneNumber
        userProfile.savedAddresses = demoUser.savedAddresses
        userProfile.favoriteItems = demoUser.favoriteItems
        userProfile.orderHistory = demoUser.orderHistory
        userProfile.preferredPaymentMethod = demoUser.preferredPaymentMethod
        userProfile.loyaltyPoints = demoUser.loyaltyPoints
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func signUp() {
        // Simplified sign up for demo
        if name.isEmpty || email.isEmpty {
            errorMessage = "Please fill out all required fields"
            showError = true
            return
        }
        
        userProfile.name = name
        userProfile.email = email
        userProfile.phoneNumber = phoneNumber
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var profile: UserProfile
    var onSave: (UserProfile) -> Void
    
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        profile.name = name
                        profile.email = email
                        profile.phoneNumber = phoneNumber
                        onSave(profile)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
            .onAppear {
                name = profile.name
                email = profile.email
                phoneNumber = profile.phoneNumber
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .environmentObject(UserProfile.demoUser)
        }
    }
}
