import SwiftUI

struct CartView: View {
    @EnvironmentObject var order: Order
    @EnvironmentObject var userProfile: UserProfile
    @State private var isShowingAddressSheet = false
    @State private var isShowingPaymentSheet = false
    @State private var specialInstructions = ""
    @State private var isCheckingOut = false
    @State private var showCheckoutSuccess = false
    
    var body: some View {
        VStack {
            if order.items.isEmpty {
                emptyCartView
            } else {
                cartContentView
            }
        }
        .navigationTitle("Your Cart")
        .sheet(isPresented: $isShowingAddressSheet) {
            AddressSelectionView(selectedAddress: $order.deliveryAddress)
                .environmentObject(userProfile)
        }
        .sheet(isPresented: $isShowingPaymentSheet) {
            PaymentMethodView(selectedMethod: $order.paymentMethod)
        }
        .overlay(
            Group {
                if showCheckoutSuccess {
                    OrderConfirmationView(isPresented: $showCheckoutSuccess)
                }
            }
        )
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
            Text("Your cart is empty")
                .font(.headline)
            
            Text("Add some delicious items to your cart to get started!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            NavigationLink(destination: HomeView()) {
                Text("Browse Menu")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.top)
            
            Spacer()
        }
    }
    
    private var cartContentView: some View {
        VStack {
            List {
                Section(header: Text("Items").font(.headline)) {
                    ForEach(order.items) { item in
                        CartItemRow(orderItem: item)
                            .environmentObject(order)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            order.removeItem(order.items[index])
                        }
                    }
                }
                
                Section(header: Text("Special Instructions").font(.headline)) {
                    TextField("Add any special instructions...", text: $specialInstructions)
                        .onChange(of: specialInstructions) { newValue in
                            order.specialInstructions = newValue
                        }
                }
                
                Section(header: Text("Delivery Details").font(.headline)) {
                    Button(action: {
                        isShowingAddressSheet = true
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading) {
                                Text(order.deliveryAddress == nil ? "Add Delivery Address" : "Delivery Address")
                                    .foregroundColor(.primary)
                                
                                if let address = order.deliveryAddress {
                                    Text(address.formattedAddress)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        isShowingPaymentSheet = true
                    }) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading) {
                                Text(order.paymentMethod == nil ? "Add Payment Method" : "Payment Method")
                                    .foregroundColor(.primary)
                                
                                if let method = order.paymentMethod {
                                    Text(method.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Order Summary").font(.headline)) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("$\(order.subtotal, specifier: "%.2f")")
                    }
                    
                    HStack {
                        Text("Tax")
                        Spacer()
                        Text("$\(order.tax, specifier: "%.2f")")
                    }
                    
                    HStack {
                        Text("Delivery Fee")
                        Spacer()
                        Text("$\(order.deliveryFee, specifier: "%.2f")")
                    }
                    
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(order.total, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                }
            }
            
            Button(action: {
                isCheckingOut = true
                
                // Simulate checkout process
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if order.checkout() {
                        showCheckoutSuccess = true
                        userProfile.addOrderToHistory(order)
                    }
                    isCheckingOut = false
                }
            }) {
                Group {
                    if isCheckingOut {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Checkout")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    (order.deliveryAddress != nil && order.paymentMethod != nil) ?
                    Color.accentColor : Color.gray
                )
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding()
            }
            .disabled(order.deliveryAddress == nil || order.paymentMethod == nil || isCheckingOut)
        }
    }
}

struct CartItemRow: View {
    let orderItem: OrderItem
    @EnvironmentObject var order: Order
    
    var body: some View {
        HStack(spacing: 15) {
            Image(orderItem.menuItem.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(orderItem.menuItem.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("$\(orderItem.totalPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                if !orderItem.specialInstructions.isEmpty {
                    Text(orderItem.specialInstructions)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Button(action: {
                        order.updateQuantity(for: orderItem, quantity: max(1, orderItem.quantity - 1))
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    
                    Text("\(orderItem.quantity)")
                        .frame(minWidth: 20)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        order.updateQuantity(for: orderItem, quantity: orderItem.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        order.removeItem(orderItem)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct AddressSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userProfile: UserProfile
    @Binding var selectedAddress: Address?
    @State private var showingAddAddressForm = false
    @State private var newAddress = Address(street: "", apartment: "", city: "", state: "", zipCode: "")
    
    var body: some View {
        NavigationView {
            List {
                if userProfile.savedAddresses.isEmpty {
                    Section {
                        HStack {
                            Spacer()
                            Text("No saved addresses yet")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                } else {
                    Section(header: Text("Saved Addresses")) {
                        ForEach(userProfile.savedAddresses, id: \.formattedAddress) { address in
                            Button(action: {
                                selectedAddress = address
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(address.label)
                                            .font(.headline)
                                        
                                        Text(address.formattedAddress)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if address.formattedAddress == selectedAddress?.formattedAddress {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        showingAddAddressForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                            Text("Add New Address")
                        }
                    }
                }
            }
            .navigationTitle("Delivery Address")
            .sheet(isPresented: $showingAddAddressForm) {
                AddAddressFormView(address: $newAddress, onSave: { address in
                    userProfile.saveAddress(address)
                    selectedAddress = address
                    presentationMode.wrappedValue.dismiss()
                })
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddAddressFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var address: Address
    var onSave: (Address) -> Void
    @State private var addressLabel = "Home"
    
    let addressLabelOptions = ["Home", "Work", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Address Details")) {
                    TextField("Street", text: $address.street)
                    TextField("Apartment/Suite (Optional)", text: $address.apartment)
                    TextField("City", text: $address.city)
                    TextField("State", text: $address.state)
                    TextField("Zip Code", text: $address.zipCode)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Label")) {
                    Picker("Label", selection: $addressLabel) {
                        ForEach(addressLabelOptions, id: \.self) { label in
                            Text(label).tag(label)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button("Save Address") {
                        address.label = addressLabel
                        onSave(address)
                    }
                    .disabled(address.street.isEmpty || address.city.isEmpty || address.state.isEmpty || address.zipCode.isEmpty)
                }
            }
            .navigationTitle("Add Address")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct PaymentMethodView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedMethod: PaymentMethod?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(PaymentMethod.allCases) { method in
                    Button(action: {
                        selectedMethod = method
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: method.systemImage)
                                .font(.title3)
                                .foregroundColor(.accentColor)
                                .frame(width: 30)
                            
                            Text(method.rawValue)
                            
                            Spacer()
                            
                            if method == selectedMethod {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Payment Method")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct OrderConfirmationView: View {
    @EnvironmentObject var order: Order
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 25) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Order Confirmed!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 10) {
                    Text("Order Number")
                        .font(.headline)
                    
                    Text(order.orderNumber)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 10) {
                    Text("Estimated Delivery Time")
                        .font(.headline)
                    
                    Text("\(order.estimatedDeliveryTime) min")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Button(action: {
                    isPresented = false
                    order.clearCart()
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 50)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(20)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        let userProfile = UserProfile.demoUser
        
        // Add some items to the cart for preview
        for item in MenuItem.previewItems.prefix(2) {
            order.addItem(item)
        }
        
        return NavigationView {
            CartView()
                .environmentObject(order)
                .environmentObject(userProfile)
        }
    }
}
