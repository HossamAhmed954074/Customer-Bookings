import 'package:customer_booking/core/secrets/secret_constatnts.dart';

class EndPoints {
  static final String baseUrl = SecretConstants.apiBaseUrl!;

  // Auth endpoints
  static final String authData = '$baseUrl/auth';
  static final String authRegister = '$authData/register';
  static final String authLogin = '$authData/login';
  static final String authProfile = '$authData/me';

  // Business endpoints
  static final String businessData = '$baseUrl/businesses';

  // Session endpoints
  static final String sessionData = '$baseUrl/sessions';

  // Booking endpoints
  static final String bookingData = '$baseUrl/bookings';

  // Credits endpoints
  static final String creditsData = '$baseUrl/credits';
  static final String creditPackages = '$baseUrl/credit-packages';
  static final String creditsPurchase = '$creditsData/purchase';
}
