# 🚀 Quick Start Guide - Home Screen

## ⚡ Immediate Setup (3 Steps)

### Step 1: Get Google Maps API Key
1. Visit: https://console.cloud.google.com/
2. Enable "Maps SDK for Android"
3. Create API Key

### Step 2: Add API Key
Open: `android/app/src/main/AndroidManifest.xml`
Replace line 11:
```xml
android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"
```
With:
```xml
android:value="AIza...YOUR_ACTUAL_KEY"
```

### Step 3: Run
```bash
flutter pub get
flutter run
```

## 📱 What You Get

- ✅ Google Maps with session markers
- ✅ Category filters (All, Yoga, Pilates, HIIT, Dance)
- ✅ Session cards with images
- ✅ API integration with your backend
- ✅ Loading states and error handling
- ✅ Clean architecture

## 🎨 Widgets Created

| Widget | Purpose |
|--------|---------|
| `HomeScreen` | Main screen with map & list |
| `CategoryFilterChip` | Filter chips (blue when selected) |
| `SessionCard` | Session info card with image |
| `FilterButton` | Advanced filter button |

## 🔌 API Used

**Endpoint:** `GET /api/v1/sessions`

**Query Params:**
- `businessId` (optional)
- `dateFrom` (optional) 
- `dateTo` (optional)

**Base URL:** Already configured in `.env`

## 🏗️ Architecture

```
Features/Home/
├── Data (API & Models)
├── Domain (Business Logic)
└── Presentation (UI & State)
```

## 🎯 Key Files

| File | What It Does |
|------|--------------|
| `home_screen.dart` | Main UI |
| `home_cubit.dart` | State management |
| `session_model.dart` | API data parsing |
| `session_remote_data_source.dart` | API calls |
| `home_injection.dart` | Dependency setup |

## 🔥 Features

- **Map View**: Shows all session locations
- **Filtering**: Tap categories to filter
- **Real-time**: Fetches from your API
- **Responsive**: Loading & error states
- **Modular**: Easy to extend

## 🛠️ Customization

**Change map location:**
Edit `home_screen.dart` line 26

**Add categories:**
Edit `home_cubit.dart` line 13

**Change card images:**
Edit `session_card.dart` line 28

## 🎨 Design Features

- Gradient overlays on cards
- Rounded corners (16px)
- Availability badges (green/red)
- Time & date icons
- Smooth scrolling

## ⚠️ Don't Forget!

1. ⚠️ **Add Google Maps API Key** (required!)
2. ✅ Dependencies already installed
3. ✅ Permissions already configured
4. ✅ API endpoint already set

## 📚 Full Documentation

- `IMPLEMENTATION_SUMMARY.md` - Complete overview
- `HOME_SCREEN_README.md` - Detailed guide

---

**Status:** ✅ Ready to use!
**Time to setup:** ~5 minutes (just add API key)
