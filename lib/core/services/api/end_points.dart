
import 'package:customer_booking/core/secrets/secret_constatnts.dart';

class EndPoints {
  static final String baseUrl = SecretConstants.apiBaseUrl!;
  static final String authData = '$baseUrl/auth';
  static final String businessData = '$baseUrl/businesses';
  static final String sessionData = '$baseUrl/sessions';
  static final String bookingData = '$baseUrl/bookings';
  static final String creditsData = '$baseUrl/credits';

}