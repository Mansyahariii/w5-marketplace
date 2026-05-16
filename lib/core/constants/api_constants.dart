class ApiConstants {
  // Gunakan 10.0.2.2 untuk Android Emulator (alias localhost komputer host)
  // Ganti ke IP jaringan (misal 192.168.x.x) jika pakai perangkat fisik
  static const String baseUrl = 'http://10.0.2.2:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';

  // Cart endpoints
  static const String cart = '/cart';

  // Order endpoints
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';

  // Timeout (dinaikkan agar tidak timeout saat emulator lambat)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
