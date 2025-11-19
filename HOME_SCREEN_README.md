# Home Screen Implementation Guide

## Overview
The home screen has been fully implemented with Google Maps integration, session filtering, and API connectivity. The screen matches the design provided and includes all necessary functionality.

## Features Implemented

### 1. **Google Maps Integration**
- Map view showing business locations with markers
- Interactive markers for each session location
- Custom camera positioning and zoom controls
- Mock label for development purposes

### 2. **Session Management**
- Fetch sessions from API with date filtering
- Display sessions in scrollable cards
- Show session details (name, instructor, time, availability)
- Category-based filtering (All, Yoga, Pilates, HIIT, Dance)

### 3. **UI Components**
- **CategoryFilterChip**: Custom filter chips for categories
- **SessionCard**: Reusable card with gradient overlay and session info
- **FilterButton**: Button to open advanced filters (placeholder)
- Header with time and calendar icon

### 4. **State Management**
- BLoC/Cubit pattern for state management
- Loading, success, and error states
- Filtered sessions based on selected category

### 5. **Architecture**
- Clean Architecture with layers:
  - Domain: Entities, Repositories, Use Cases
  - Data: Models, Data Sources, Repository Implementation
  - Presentation: Screens, Widgets, Cubits

## Setup Instructions

### 1. **Install Dependencies**
Run the following command to install all required packages:
\`\`\`bash
flutter pub get
\`\`\`

### 2. **Configure Google Maps API Key**

#### For Android:
1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS (if targeting iOS)
   - Geolocation API
3. Open `android/app/src/main/AndroidManifest.xml`
4. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
   \`\`\`xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY_HERE"/>
   \`\`\`

#### For iOS (Optional):
1. Open `ios/Runner/AppDelegate.swift`
2. Add the following import at the top:
   \`\`\`swift
   import GoogleMaps
   \`\`\`
3. Add the API key in the `application` method:
   \`\`\`swift
   GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
   \`\`\`

### 3. **Configure API Base URL**
The API base URL is already configured in `.env`:
\`\`\`
API_BASE_URL=https://booking-classes-api.onrender.com/api/v1
\`\`\`

### 4. **Run the Application**
\`\`\`bash
flutter run
\`\`\`

## API Integration

### Sessions API
The app uses the following endpoints:

1. **List Sessions** (GET)
   - Endpoint: `/api/v1/sessions`
   - Query Parameters:
     - `businessId` (optional): Filter by business
     - `dateFrom` (optional): Start date filter
     - `dateTo` (optional): End date filter

2. **Get Session Detail** (GET)
   - Endpoint: `/api/v1/sessions/{sessionId}`

### Sample API Response
\`\`\`json
{
  "data": [
    {
      "_id": "507f1f77bcf86cd799439013",
      "businessId": "507f1f77bcf86cd799439012",
      "name": "Yoga Class",
      "instructorName": "John Doe",
      "description": "Beginner yoga class",
      "date": "2025-11-20T09:00:00Z",
      "startTime": "09:00",
      "endTime": "10:00",
      "duration": 60,
      "capacity": 20,
      "bookedCount": 5,
      "credits": 15,
      "level": "all",
      "business": {
        "name": "Fitness Studio",
        "address": "123 Main St",
        "location": {
          "coordinates": [-122.4194, 37.7749]
        }
      }
    }
  ]
}
\`\`\`

## File Structure

\`\`\`
lib/
├── features/
│   └── home/
│       ├── data/
│       │   ├── datasource/
│       │   │   └── session_remote_data_source.dart
│       │   ├── models/
│       │   │   └── session_model.dart
│       │   └── repo/
│       │       └── session_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── session.dart
│       │   ├── repo/
│       │   │   └── session_repository.dart
│       │   └── usecases/
│       │       ├── get_sessions_usecase.dart
│       │       └── get_session_detail_usecase.dart
│       ├── presentation/
│       │   ├── cubits/
│       │   │   ├── home_cubit.dart
│       │   │   └── home_state.dart
│       │   ├── screens/
│       │   │   └── home_screen.dart
│       │   └── widgets/
│       │       ├── category_filter_chip.dart
│       │       ├── filter_button.dart
│       │       └── session_card.dart
│       └── home_injection.dart
└── core/
    ├── services/
    │   └── api/
    └── routers/
        └── router.dart
\`\`\`

## Key Components

### 1. Session Entity
Core business object representing a fitness session with all necessary properties.

### 2. HomeCubit
Manages the state of the home screen including:
- Loading sessions from API
- Filtering by category
- Handling errors and loading states

### 3. HomeScreen
Main screen widget that combines:
- Google Maps view
- Category filter chips
- Session list with cards

### 4. Session Card
Reusable widget displaying session information with:
- Background image
- Gradient overlay
- Session name and instructor
- Time and date
- Available spots indicator

## Customization

### Change Default Map Location
Edit `_initialPosition` in `home_screen.dart`:
\`\`\`dart
static const CameraPosition _initialPosition = CameraPosition(
  target: LatLng(YOUR_LAT, YOUR_LNG),
  zoom: 12,
);
\`\`\`

### Add More Categories
Update `categories` list in `home_cubit.dart`:
\`\`\`dart
final List<String> categories = [
  'All',
  'Yoga',
  'Pilates',
  'HIIT',
  'Dance',
  'Your_New_Category', // Add here
];
\`\`\`

### Customize Session Card Images
Replace the default image URL in `session_card.dart`:
\`\`\`dart
image: DecorationImage(
  image: NetworkImage('YOUR_IMAGE_URL'),
  fit: BoxFit.cover,
),
\`\`\`

## Testing

To test the implementation:

1. Ensure you're logged in (the router will redirect to login if not authenticated)
2. The home screen will load and fetch sessions from the API
3. Try selecting different categories to filter sessions
4. Tap on session cards to see the placeholder detail action
5. Tap the filter button to see the placeholder filter dialog

## Troubleshooting

### Map Not Showing
- Verify Google Maps API key is correctly configured
- Check that billing is enabled on your Google Cloud project
- Ensure the Maps SDK for Android is enabled

### No Sessions Displayed
- Check network connectivity
- Verify API base URL in `.env` file
- Check API response in debug logs
- Ensure date range includes available sessions

### Build Errors
- Run `flutter clean`
- Run `flutter pub get`
- Restart your IDE

## Next Steps

1. **Session Detail Screen**: Create detailed view for individual sessions
2. **Booking Functionality**: Implement session booking flow
3. **User Location**: Add user's current location to the map
4. **Advanced Filters**: Implement date picker and additional filters
5. **Pull to Refresh**: Add swipe-down refresh gesture
6. **Favorites**: Allow users to save favorite sessions
7. **Push Notifications**: Notify users about upcoming sessions

## Notes

- The session images currently use a placeholder URL from Unsplash
- The filter button shows a placeholder snackbar
- Session detail navigation shows a placeholder snackbar
- Location permissions should be handled for production use
