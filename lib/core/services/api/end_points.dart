
import 'package:customer_booking/core/secrets/secret_constatnts.dart';

class EndPoints {
  static final String baseUrl = SecretConstants.apiBaseUrl!;
  static final String userData = '$baseUrl/user';
  static final String productData = '$baseUrl/product';
  static final String shipmentData = '$baseUrl/shipment';
  static final String clientData = '$baseUrl/client';
}