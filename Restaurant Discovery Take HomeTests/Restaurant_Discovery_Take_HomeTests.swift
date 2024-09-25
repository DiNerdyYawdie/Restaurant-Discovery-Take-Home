//
//  Restaurant_Discovery_Take_HomeTests.swift
//  Restaurant Discovery Take HomeTests
//
//  Created by Chad-Michael Muirhead on 9/22/24.
//

import XCTest
@testable import Restaurant_Discovery_Take_Home

final class Restaurant_Discovery_Take_HomeTests: XCTestCase {

    var viewModel: RestaurantsViewModel!
    
    var mockRestaurantService: MockRestaurantServicesImpl!
    var mockLocationService: MockLocationServiceImpl!
    
    @MainActor override func setUp() {
        mockRestaurantService = MockRestaurantServicesImpl()
        mockLocationService = MockLocationServiceImpl()
        viewModel = RestaurantsViewModel(restaurantServices: mockRestaurantService, locationServices: mockLocationService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRestaurantService = nil
        mockLocationService = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchNearbyRestaurantsSuccessful() async throws {
        // Given
        
        let mockRestaurant = Restaurant(id: "1234", formattedAddress: "1 Highway Ave", rating: 4, userRatingCount: 4, displayName: RestaurantLocalizedText(text: "Ms Lilys"), photos: [], location: RestaurantLocation(latitude: 0, longitude: 0), generativeSummary: nil, regularOpeningHours: RegularOpeningHours(openNow: true, weekdayDescriptions: ["Monday 8am - 8pm"]), nationalPhoneNumber: "876123456789")
        
        mockRestaurantService.nearbyRestaurantsResult = .success([mockRestaurant])
        mockLocationService.userLocationResult = .success(RestaurantLocation(latitude: 0, longitude: 0))
        
        // When
        await viewModel.fetchNearbyRestaurants()
        
        // Then
        XCTAssertNotNil(viewModel.userLocation)
        XCTAssertFalse(viewModel.showPermissionsAlert)
        
        XCTAssertEqual(viewModel.restaurants.count, 1)
        XCTAssertEqual(viewModel.restaurants[0].id, "1234")
        XCTAssertEqual(viewModel.restaurants[0].displayName.text, "Ms Lilys")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testFetchNearbyRestaurantsFailureWithUserLocation() async throws {
        // Given
        
        mockRestaurantService.nearbyRestaurantsResult = .failure(RestaurantServicesError.decodeError)
        mockLocationService.userLocationResult = .success(RestaurantLocation(latitude: 0, longitude: 0))
        
        // When
        await viewModel.fetchNearbyRestaurants()
        
        // Then
        XCTAssertNotNil(viewModel.userLocation)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.restaurants.isEmpty)
        XCTAssertEqual(viewModel.errorAlertTitle, RestaurantServicesError.decodeError.errorMessage)
    }
    
    @MainActor
    func testFetchNearbyRestaurantsURLErrorFailure() async throws {
        // Given
        
        mockRestaurantService.nearbyRestaurantsResult = .failure(RestaurantServicesError.urlError)
        mockLocationService.userLocationResult = .success(RestaurantLocation(latitude: 0, longitude: 0))
        
        // When
        await viewModel.fetchNearbyRestaurants()
        
        // Then
        XCTAssertNotNil(viewModel.userLocation)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.restaurants.isEmpty)
        XCTAssertEqual(viewModel.errorAlertTitle, RestaurantServicesError.urlError.errorMessage)
    }
    
    @MainActor
    func testFetchNearbyRestaurantsHTTPErrorFailure() async throws {
        // Given
        
        mockRestaurantService.nearbyRestaurantsResult = .failure(RestaurantServicesError.httpError)
        mockLocationService.userLocationResult = .success(RestaurantLocation(latitude: 0, longitude: 0))
        
        // When
        await viewModel.fetchNearbyRestaurants()
        
        // Then
        XCTAssertNotNil(viewModel.userLocation)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.restaurants.isEmpty)
        XCTAssertEqual(viewModel.errorAlertTitle, RestaurantServicesError.httpError.errorMessage)
    }
    
    @MainActor
    func testAuthorizationDenied() async {
        // Given
        mockLocationService.mockLocationAuthStatus = .denied
        
        
        // Then
        await viewModel.fetchNearbyRestaurants()
        
        XCTAssertNil(viewModel.userLocation)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.restaurants.isEmpty)
        
    }
    
    @MainActor
    func testCheckLocationAuthorization_Authorized() async {
        // Arrange
        mockLocationService.mockLocationAuthStatus = .authorized
        mockLocationService.userLocationResult = .success(RestaurantLocation(latitude: 37.7749, longitude: -122.4194))
        
        // Act
        await viewModel.checkLocationAuthorization()
        
        // Assert
        XCTAssertNotNil(viewModel.userLocation)
        XCTAssertFalse(viewModel.showPermissionsAlert)
    }
    
    @MainActor
    func testCheckLocationAuthorization_Denied() async {
        // Arrange
        mockLocationService.mockLocationAuthStatus = .denied
        
        // Act
        await viewModel.checkLocationAuthorization()
        
        // Assert
        XCTAssertTrue(viewModel.showPermissionsAlert)
        XCTAssertNil(viewModel.userLocation)
    }
    
    @MainActor
    func testSearchRestaurants_Success() async {
        // Arrange
        let mockRestaurant = Restaurant(id: "1234", formattedAddress: "86 March Lane", rating: 3, userRatingCount: 4, displayName: RestaurantLocalizedText(text: "Fish N Tingz"), photos: [], location: RestaurantLocation(latitude: 37.7749, longitude: -18.948), generativeSummary: nil, regularOpeningHours: RegularOpeningHours(openNow: true, weekdayDescriptions: ["Monday 8am - 8pm"]), nationalPhoneNumber: "876123456789")
        mockRestaurantService.searchRestaurantsResult = .success([mockRestaurant])
        
        // Act
        viewModel.searchText = "Fish"
        await viewModel.searchRestaurants()
        
        // Assert
        XCTAssertEqual(viewModel.restaurants.count, 1)
        XCTAssertEqual(viewModel.restaurants.first?.displayName.text, "Fish N Tingz")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.mapCoordinateRegion.center.latitude, 37.7749)
        XCTAssertEqual(viewModel.mapCoordinateRegion.center.longitude, -18.948)
    }

    @MainActor
    func testSearchRestaurants_Failure() async {
        // Arrange
        mockRestaurantService.searchRestaurantsResult = .failure(RestaurantServicesError.decodeError)
        
        // Act
        viewModel.searchText = "Test"
        await viewModel.searchRestaurants()
        
        // Assert
        XCTAssertEqual(viewModel.restaurants.count, 0)
        XCTAssertEqual(viewModel.errorAlertTitle, RestaurantServicesError.decodeError.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testUpdateFavorite_AddsFavorite() {
        // Given
        let mockRestaurant = Restaurant(id: "1234", formattedAddress: "1 Highway Ave", rating: 4, userRatingCount: 4, displayName: RestaurantLocalizedText(text: "Ms Lilys"), photos: [], location: RestaurantLocation(latitude: 0, longitude: 0), generativeSummary: nil, regularOpeningHours: RegularOpeningHours(openNow: true, weekdayDescriptions: ["Monday 8am - 8pm"]), nationalPhoneNumber: "876123456789", isFavorite: false)
        viewModel.restaurants = [mockRestaurant]
        
        // Act
        viewModel.updateFavorite(restaurant: mockRestaurant)
        
        // Assert
        XCTAssertTrue(viewModel.restaurants.first?.isFavorite ?? false)
        XCTAssertTrue(UserDefaults.standard.getFavorites().contains(mockRestaurant.id))
    }
    
    @MainActor
    func testUpdateFavorite_RemovesFavorite() {
        // Given
        let mockRestaurant = Restaurant(id: "1234", formattedAddress: "1 Highway Ave", rating: 4, userRatingCount: 4, displayName: RestaurantLocalizedText(text: "Ms Lilys"), photos: [], location: RestaurantLocation(latitude: 0, longitude: 0), generativeSummary: nil, regularOpeningHours: RegularOpeningHours(openNow: true, weekdayDescriptions: ["Monday 8am - 8pm"]), nationalPhoneNumber: "876123456789", isFavorite: true)
        
        viewModel.restaurants = [mockRestaurant]
        UserDefaults.standard.saveFavorite(restaurant: mockRestaurant)
        
        // Act
        viewModel.updateFavorite(restaurant: mockRestaurant)
        
        // Assert
        XCTAssertFalse(viewModel.restaurants.first?.isFavorite ?? false)
    }
}
