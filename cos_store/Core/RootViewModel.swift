//
//  StoreViewModel.swift
//  cos_store
//
//  Created by Vlad Sushko on 06/05/2024.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
final class RootViewModel: ObservableObject {
    
    let authManager = AuthManager()
    let productManager = ProductManager()
    let storageManager = StorageManager()
    let userManager = UserManager()
    let orderManager = OrderManager()
    
    var userId: String = ""
    var userEmail: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var products: [Product] = []
    @Published var selectedSortOption: SortOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    @Published var selectedBrand: BrandOption? = nil
    @Published var lastDocument: DocumentSnapshot? = nil
    @Published var productsCount: Int? = nil
    @Published var searchText: String = ""
    
    // MARK: - PROFILE
    @Published private(set) var user: DBUser? = nil
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    // MARK: - CART
    @Published var cartPositions: [CartPosition] = [] {
        didSet {
            getCartTotalPrice()
        }
    }
    
    @Published var cartPositionProducts: [Product] = []
    @Published var cartTotalPrice: Double = 00.00
    
    // MARK: - FAVORITES
    @Published private(set) var favoritesProducts: [DBUserFavoriteProduct] = []
    
    // MARK: - ORDER
    @Published var order: Order? = nil
    @Published var orders: [Order]? = nil
    
    enum BrandOption: String, CaseIterable {
        case all = "All"
        case needly = "NEEDLY"
        case drCeuracle = "Dr. Ceuracle"
        case roundLab = "Round Lab"
        case cuSkin = "CUSKIN"
        case atache = "Atache"
        case theramid = "Theramid"
        
        var brandKey: String? {
            if self == .all {
                return nil
            }
            return self.rawValue
        }
    }
    
    enum SortOption: String, CaseIterable {
        case recommended = "Recommended"
        case priceHighToLow = "Price: High to Low"
        case priceLowToHigh = "Price: Low to High"
        
        var priceDescending: Bool? {
            switch self {
            case .recommended: return nil
            case .priceHighToLow: return true
            case .priceLowToHigh: return false
            }
        }
    }
    
    enum CategoryOption: String, CaseIterable {
        case All
        case Cleanser
        case Toner
        case Moisturizer
        case SunCare
        case EyeCare
        case LipCare
        case Mask
        case Serum
        case Treatment
        case ChemicalPeel
        
        var categoryKey: String? {
            if self == .All {
                return nil
            }
            return self.rawValue
        }
    }
    
    init() {
        getUserId()
        getUserEmail()
    }
    
    func sortOptionSelected(option: SortOption) async throws {
        self.selectedSortOption = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func categorySelected(category: CategoryOption) async throws {
        self.selectedCategory = category
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func brandSelected(brand: BrandOption) async throws {
        self.selectedBrand = brand
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productManager.getProduct(productID: productId)
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await
            productManager.getProducts(priceDescending: selectedSortOption?.priceDescending, forCategory: selectedCategory?.categoryKey, selectedBrand: selectedBrand?.brandKey, count: 6, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getUserId() {
        if let userId = try? authManager.getAuthenticatedUser().uid {
            self.userId = userId
        }
    }
    
    func getUserEmail() {
        if let userEmail = try? authManager.getAuthenticatedUser().email {
            self.userEmail = userEmail
        }
    }
    
    func getProductCount() {
        Task {
            self.productsCount = try await productManager.getProductsCount()
        }
    }
    
    // MARK: - PROFILE
    
    func loadAuthUser() {
        self.authUser = try? authManager.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try authManager.signOut()
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try authManager.getAuthenticatedUser()
        self.user = try await userManager.getUser(userId: authDataResult.uid)
    }
    
    func loadAuthProviders() {
        if let providers = try? authManager.getProviders() {
            authProviders = providers
        }
    }

    // MARK: - FAVORITES

    func addListenerForFavorites() {
        userManager.addListenerForGetAllFavoriteProducts(userId: userId)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.favoritesProducts = products
            }
            .store(in: &cancellables)
    }
    
    func addUserFavoriteProduct(productId: String) {
        Task {
            try await userManager.addFavoriteProduct(userId: userId, productId: productId)
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            try await userManager.removeFavoriteProduct(userId: userId, favoriteProductId: favoriteProductId)
        }
    }
    
    // MARK: - CART
    
    func addListenerForCartPositions() {
        userManager.addListenerForGetCartPositions(userId: userId)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.cartPositions = products
            }
            .store(in: &cancellables)
    }
    
    //TODO: ERROR HANDLE
    func addProductToCart(productId: String, count: Int = 1) async throws {
        Task {
            guard let productPrice = try await productManager.getProductPrice(productID: productId) else {
                throw GeneralError.dataNotFound
            }
            let salePrice = try await productManager.getProductSalePrice(productID: productId)
            try await userManager.addProductToCart(userId: userId, productId: productId, price: productPrice, salePrice: salePrice, count: count)
        }
    }
    
    func getProductsInCart(userId: String) async throws {
        Task {
            self.cartPositions = try await userManager.getProductsInCart(userId: userId)
        }
    }
    
    func removeCartPosition(productId: String) {
        Task {
            try await userManager.removeCartProduct(userId: userId, productId: productId)
        }
    }
    
    func cleanCart() async throws {
        try await userManager.removeCartProducts(userId: userId, cartPositions: cartPositions)
    }
    
    func getProductsFromCartPositions() async {
        var productsArray: [Product] = []
        for product in cartPositions {
            if let convertedProduct = try? await getProduct(productId: product.id) {
                productsArray.append(convertedProduct)
            }
        }
        self.cartPositionProducts = productsArray
    }
    
    func getProductFromCartPosition(cartPosition: CartPosition) async throws -> Product {
        try await getProduct(productId: cartPosition.id)
    }
    
    func changeCartPositionCount(count: Int, userId: String, cartPositionId: String) async throws {
        try await userManager.increaseCartPositionCount(count: count, userId: userId, cartPositionId: cartPositionId)
    }
    
    func getCartTotalPrice() {
        var sum = 00.00
        for position in cartPositions {
            if let salePrice = position.salePrice {
                sum += salePrice * Double(position.count)
                
            } else {
                sum += position.price * Double(position.count)
            }
        }
        self.cartTotalPrice = sum
    }
    
    
    // MARK: - ORDER
    
    func createOrder(userID: String, paymentMethod: String, deliveryInformation: DeliveryInformation) async throws {
        let order = Order(id: UUID().uuidString,
                          userId: userID,
                          userEmail: userEmail,
                          positions: cartPositions,
                          status: Order.OrderStatus.waitingForPayment.rawValue,
                          paymentMethod: paymentMethod,
                          paymentStatus: Order.PaymentStatus.inProcess.rawValue,
                          total: cartTotalPrice,
                          deliveryInformation: deliveryInformation,
                          dateCreated: Date.now)
        
        try await orderManager.createOrder(userId: userID, order: order)
        try await orderManager.addOrderToGlobalCollection(order: order)
    }
    
    func getUserOrders() async throws {
        self.orders = try await orderManager.getUserOrders(userId: userId)
    }
}

