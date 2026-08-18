import 'dart:io';
import 'dart:math';
import 'package:erp_software/core/config/app_config.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  /// Generates a random 6-digit numeric OTP string (e.g., "482915")
  String generateOtp() {
    final random = Random.secure();
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }

  /// Sends password reset OTP to user email.
  /// If SMTP credentials (SMTP_USER and SMTP_PASS) are set in .env, dispatches real email via SMTP.
  /// Otherwise, logs to console stdout for developer testing.
  Future<bool> sendOtpEmail(String email, String otpCode) async {
    final smtpHost = AppConfig.smtpHost;
    final smtpPort = AppConfig.smtpPort;
    final smtpUser = AppConfig.smtpUser;
    final smtpPass = AppConfig.smtpPass;
    final senderName = AppConfig.smtpSenderName;
    final enableTls = AppConfig.smtpEnableTls;

    // Always log to stdout so developers can test locally even without real SMTP
    _logOtpConsole(email, otpCode);

    // If SMTP credentials are provided, send a real email
    if (smtpUser.isNotEmpty && smtpPass.isNotEmpty) {
      try {
        SmtpServer smtpServer;
        if (smtpHost.contains('gmail')) {
          smtpServer = gmail(smtpUser, smtpPass);
        } else {
          smtpServer = SmtpServer(
            smtpHost,
            port: smtpPort,
            ssl: smtpPort == 465,
            allowInsecure: !enableTls,
            username: smtpUser,
            password: smtpPass,
          );
        }

        final message = Message()
          ..from = Address(smtpUser, senderName)
          ..recipients.add(email)
          ..subject = '🔑 Password Reset OTP Code - ERP System'
          ..html = _buildOtpHtmlTemplate(otpCode, email);

        final sendReport = await send(message, smtpServer);
        stdout.writeln(' [EMAIL SERVICE] Real email sent successfully to $email via SMTP (Report: $sendReport)');
        return true;
      } catch (e) {
        stderr.writeln(' [EMAIL SERVICE ERROR] Failed to send email via SMTP to $email: $e');
        return false;
      }
    } else {
      stdout.writeln('====================================================');
      stdout.writeln(' [EMAIL SERVICE NOTICE] Real email dispatch disabled.');
      stdout.writeln(' SMTP_USER and SMTP_PASS are empty in .env');
      stdout.writeln(' To receive real emails in your inbox, add your Gmail / SMTP settings to .env.');
      stdout.writeln('====================================================');
      return true;
    }
  }

  void _logOtpConsole(String email, String otpCode) {
    stdout.writeln('====================================================');
    stdout.writeln(' [EMAIL SERVICE] PASSWORD RESET OTP DISPATCHED');
    stdout.writeln(' Recipient: $email');
    stdout.writeln(' OTP Code : $otpCode');
    stdout.writeln(' Valid For: 15 minutes');
    stdout.writeln('====================================================');
  }

  String _buildOtpHtmlTemplate(String otpCode, String recipientEmail) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 20px; color: #333; }
    .container { max-width: 550px; margin: 0 auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
    .header { background: linear-gradient(135deg, #6C5CE7, #a29bfe); padding: 30px 20px; text-align: center; color: #ffffff; }
    .header h1 { margin: 0; font-size: 24px; font-weight: 700; letter-spacing: 0.5px; }
    .content { padding: 30px 25px; text-align: center; }
    .otp-card { background: #f8f9fe; border: 2px dashed #6C5CE7; border-radius: 10px; padding: 20px; margin: 25px 0; display: inline-block; width: 80%; }
    .otp-code { font-size: 36px; font-weight: 800; color: #6C5CE7; letter-spacing: 8px; margin: 5px 0; }
    .expiry { color: #888; font-size: 13px; margin-top: 5px; }
    .footer { background: #f1f3f7; padding: 15px; text-align: center; font-size: 12px; color: #777; border-top: 1px solid #e0e0e0; }
    .note { font-size: 13px; color: #666; margin-top: 20px; line-height: 1.5; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>ERP System</h1>
    </div>
    <div class="content">
      <h2>Password Reset Verification</h2>
      <p class="note">We received a request to reset the password for your account <strong>$recipientEmail</strong>.</p>
      <div class="otp-card">
        <div style="font-size: 12px; color: #666; text-transform: uppercase; font-weight: bold;">Your OTP Verification Code</div>
        <div class="otp-code">$otpCode</div>
        <div class="expiry">⏱️ Valid for 15 minutes</div>
      </div>
      <p class="note">If you did not request a password reset, please ignore this email or contact your administrator immediately.</p>
    </div>
    <div class="footer">
      &copy; 2026 ERP Management System. All rights reserved.
    </div>
  </div>
</body>
</html>
''';
  }
}

