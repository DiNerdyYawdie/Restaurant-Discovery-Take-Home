## Restaurant Discovery
For this project I worked on adding the Google Places(New) API, to allow users to search for restaurants Nearby and by Search term/text. I used the MVVM architecture for the app, using a Model, View & ViewModel. I also included some unit tests for testing functionality.
Also allows the user to favorite a restaurant, by saving the restaurant's ID to `UserDefaults`.


## Architecture
For the project i used the MVVM architecture to allow for separation of the business logic from the views and models. Also for ease in creating unit tests.

 - Models: 
        1. `Restaurant`: model presented in the list to represent each restaurant from API.
        Used`RestaurantResponse` & `Restaurant` models, to decode the data retrieved to represent each restaurant.
        2. There are other Nested models used too such as `RestaurantLocation`, `RestaurantLocalizedText` and more in the `Models.swift` file.
        3. For `Restaurant` I added a extra parameter called `isFavorite`, to allow for the toggling of the favorite status of the restaurant.
 
- ViewModels:
    ### RestaurantsViewModel
        1. Created the `RestaurantsViewModel` to handle the business logic and dependecies(`RestaurantServices`) for the `RestaurantsView`
        2. Uses the service dependency to fetch data and pass it to the view(`RestaurantsView`).
        3. Uses `checkLocationAuthorization` to check the status of the `locationAuthorizationStatus` and handle based on the status.
        4. If the user has Denied permissions for location, I present them with an alert.
        To handle this I toggle, `showPermissionsAlert` to show an alert and then allow the user to update permissions in `Settings` by calling `openSettingsToEnableLocationServices`
        
        - Map Flow
        1. For showing/hiding the map i used `viewModel.showMapView`
        2. For updating the location shown on the map, I updated `viewModel.mapCoordinateRegion`.
            - After the user's location is found I update `viewModel.mapCoordinateRegion`, with the new coordinates to refocus the Map. This helps since the restaurants shown on the map, will be in close vicinty.
            - If the user decides to search for a restaurant, I update `viewModel.mapCoordinateRegion`, with the location of the first restaurant.
            This ensures that the map refocuses to show any new restaurants.
            
   ##Note: 
         For each restaurant on the map, they are presented using `MapAnnotation`, with a custom view. To ensure that the details are shown above a Annotation after its tapped, I add the detail view `RestaurantCardView` as an overlay.
         Then move the `offset` up by `-50` to ensure that it is Above the annotation.
        
         I did it this way because i notice there were some cases where other MapAnnotations were shown on top of the detail card(`RestaurantCardView`), when just having it in a `VStack`.
            
            
            
    ### RestaurantCardViewModel
        1. Used to handle logic for each `RestaurantCardView`. Handles the formatting of the URL needed to download and show the photo for each restaurant.

- Views:

    1. `RestaurantsView` - shows the list/map annotations of all the restaurants provided by the API
    2. `RestaurantCardView` - view that represents each restaurant inside the List in `RestaurantsView` and also to show detail on Map, after a annotation is selected.
    3. `RestaurantMapView` - used to show restaurants on the Map, using `MapAnnotations`. Based on the user location or the selected restaurant, the Map's center is refocused.

## API Services

### Restaurant Services
    1. `RestaurantServices` - used to fetch the list of restaurants nearby provided by the API, using:
            `func fetchNearbyRestaurants(latitude: Double, longitude: Double, query: String) async throws -> [Restaurant]`
    2. Also to fetch restaurants based on a searchterm I use `func searchRestaurants(with query: String)`
    3. Provides custom errors `RestaurantServicesError`, allow with a readable error message using `errorMessage` property it has

 
 ### Location Service
1. `LocationServices` & `LocationServicesImpl` are used to handle retriving the user's location. 

2. It also checks if location authroization status has changed by using `locationAuthorizationStatusPublisher`, to publish whenever location is updated in `func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)`

   ##Note:
     If the user denies permission they will get an `Alert`, giving them the option to update permission in settings. Handled using `RestaurantsViewModel.func openSettingsToEnableLocationServices()`
    

## Endpoints
1. `Endpoints` - enum used to handle getting the specific endpoints needed for:
    Fetching all restaurants based on user location: "https://places.googleapis.com/v1/places:searchNearby"
    Fetching restaurants based on a search term entered: "https://places.googleapis.com/v1/places:searchText"
    
    2. Contains the API_Key

