import 'package:dotenv/dotenv.dart';

class AppConfig {
  static final DotEnv _env = DotEnv()..load();

  static String get dbHost => _env['DB_HOST'] ?? 'localhost';
  static int get dbPort => int.tryParse(_env['DB_PORT'] ?? '5432') ?? 5432;
  static String get dbName => _env['DB_NAME'] ?? 'Erp';
  static String get dbUser => _env['DB_USER'] ?? 'postgres';
  static String get dbPassword => _env['DB_PASSWORD'] ?? '';
  static int get apiPort => int.tryParse(_env['API_PORT'] ?? '5000') ?? 5000;
  static String get jwtSecret => _env['JWT_SECRET'] ?? 'default_erp_jwt_secret_key';

  // SMTP Email Settings
  static String get smtpHost => _env['SMTP_HOST'] ?? '';
  static int get smtpPort => int.tryParse(_env['SMTP_PORT'] ?? '587') ?? 587;
  static String get smtpUser => _env['SMTP_USER'] ?? '';
  static String get smtpPass => _env['SMTP_PASS'] ?? '';
  static String get smtpSenderName => _env['SMTP_SENDER_NAME'] ?? 'ERP System';
  static bool get smtpEnableTls => (_env['SMTP_ENABLE_TLS'] ?? 'true').toLowerCase() == 'true';
}
