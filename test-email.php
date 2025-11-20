<?php
// Simple test script to check email configuration
// Run with: php test-email.php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Config;

echo "=== Email Configuration Test ===\n\n";

// Display current configuration
echo "MAIL_MAILER: " . env('MAIL_MAILER') . "\n";
echo "MAIL_HOST: " . env('MAIL_HOST') . "\n";
echo "MAIL_PORT: " . env('MAIL_PORT') . "\n";
echo "MAIL_USERNAME: " . env('MAIL_USERNAME') . "\n";
echo "MAIL_PASSWORD: " . (env('MAIL_PASSWORD') ? '*** (set)' : '(not set)') . "\n";
echo "MAIL_ENCRYPTION: " . env('MAIL_ENCRYPTION') . "\n";
echo "MAIL_FROM_ADDRESS: " . env('MAIL_FROM_ADDRESS') . "\n";
echo "\n";

// Check if password is still the placeholder
if (env('MAIL_PASSWORD') === 'your_app_password_here') {
    echo "❌ ERROR: You need to replace 'your_app_password_here' with actual Gmail App Password!\n\n";
    echo "Steps to generate Gmail App Password:\n";
    echo "1. Go to: https://myaccount.google.com/apppasswords\n";
    echo "2. Sign in with arnubdatta17@gmail.com\n";
    echo "3. Create new App Password for 'Mail'\n";
    echo "4. Copy the 16-character password\n";
    echo "5. Update MAIL_PASSWORD in .env file\n";
    echo "6. Run: php artisan config:clear\n";
    exit(1);
}

// Test email sending
echo "Attempting to send test email...\n";

try {
    Mail::raw('This is a test email from InsightEdu. If you receive this, email configuration is working!', function ($message) {
        $message->to(env('MAIL_USERNAME'))
                ->subject('InsightEdu - Email Test');
    });
    
    echo "✅ Test email sent successfully!\n";
    echo "Check inbox of: " . env('MAIL_USERNAME') . "\n";
} catch (\Exception $e) {
    echo "❌ Failed to send email:\n";
    echo "Error: " . $e->getMessage() . "\n\n";
    
    if (str_contains($e->getMessage(), 'Authentication')) {
        echo "💡 This looks like an authentication error.\n";
        echo "   Make sure you're using a Gmail App Password, not regular password.\n";
    } elseif (str_contains($e->getMessage(), 'Connection')) {
        echo "💡 This looks like a connection error.\n";
        echo "   Make sure your internet is working and Gmail SMTP is accessible.\n";
    }
}

echo "\n=== Test Complete ===\n";
