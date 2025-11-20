# Render Email Configuration Guide

## Problem
Emails are not being sent on the deployed Render site because email environment variables are not configured.

## Solution: Add Email Variables to Render

### Step 1: Go to Render Dashboard
1. Visit [https://dashboard.render.com](https://dashboard.render.com)
2. Click on your **insight-edu** web service
3. Click **Environment** tab in the left sidebar

### Step 2: Add These Environment Variables

Click "Add Environment Variable" for each:

```
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=zahed01x@gmail.com
MAIL_PASSWORD=jlsg idzx onxb jamw
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=zahed01x@gmail.com
MAIL_FROM_NAME=InsightEdu
```

### Step 3: IMPORTANT - Gmail App Password

⚠️ **The password `jlsg idzx onxb jamw` is a Gmail App Password (not regular password)**

If this password stops working, you need to generate a new App Password:

1. Go to [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
2. Sign in with `zahed01x@gmail.com`
3. Select "Mail" and "Other (Custom name)"
4. Enter: "InsightEdu Render"
5. Click "Generate"
6. Copy the 16-character password (e.g., `xxxx xxxx xxxx xxxx`)
7. Update `MAIL_PASSWORD` on Render with the new password

### Step 4: Alternative - Use Mailtrap for Testing

If you want to TEST emails without actually sending them:

```
MAIL_MAILER=smtp
MAIL_HOST=sandbox.smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_mailtrap_username
MAIL_PASSWORD=your_mailtrap_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@insightedu.com
MAIL_FROM_NAME=InsightEdu
```

Get credentials from: [https://mailtrap.io](https://mailtrap.io)

### Step 5: Save and Redeploy

1. After adding all variables, Render will automatically redeploy
2. Wait 2-3 minutes for deployment to complete
3. Test registration again

## Testing Email Functionality

### Test 1: Register New Account
1. Go to `/register`
2. Fill form with @diu.edu.bd email
3. Submit form
4. Should redirect to verification page
5. Check your email inbox for 6-digit code

### Test 2: Check Laravel Logs on Render

If emails still don't work, check logs:

1. In Render dashboard, go to **Logs** tab
2. Look for errors like:
   - `Failed to send verification code email`
   - `Connection refused`
   - `Authentication failed`

### Common Issues

#### Issue 1: "Connection refused"
**Solution:** Gmail is blocking the connection
- Ensure 2-factor authentication is enabled on Gmail
- Generate new App Password
- Make sure you're using `smtp.gmail.com` not `smtp.google.com`

#### Issue 2: "Authentication failed"
**Solution:** Wrong password
- Verify App Password is correct (no spaces)
- Password should be 16 characters from Google App Passwords

#### Issue 3: "Less secure app access"
**Solution:** Use App Password instead
- Gmail no longer supports "less secure apps"
- MUST use App Passwords with 2FA enabled

#### Issue 4: Emails go to Spam
**Solution:** Add SPF/DKIM records or use transactional email service
- Consider using SendGrid, Mailgun, or AWS SES for production
- Free tiers available for all

## Production Email Services (Recommended)

For production deployment, consider:

### 1. SendGrid (12,000 free emails/month)
```
MAIL_MAILER=smtp
MAIL_HOST=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=apikey
MAIL_PASSWORD=your_sendgrid_api_key
MAIL_ENCRYPTION=tls
```

### 2. Mailgun (5,000 free emails/month)
```
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailgun.org
MAIL_PORT=587
MAIL_USERNAME=postmaster@yourdomain.mailgun.org
MAIL_PASSWORD=your_mailgun_password
MAIL_ENCRYPTION=tls
```

### 3. AWS SES (62,000 free emails/month)
```
MAIL_MAILER=ses
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=us-east-1
```

## Quick Fix Checklist

- [ ] Add MAIL_MAILER=smtp to Render env
- [ ] Add MAIL_HOST=smtp.gmail.com to Render env
- [ ] Add MAIL_PORT=587 to Render env
- [ ] Add MAIL_USERNAME=zahed01x@gmail.com to Render env
- [ ] Add MAIL_PASSWORD with App Password to Render env
- [ ] Add MAIL_ENCRYPTION=tls to Render env
- [ ] Add MAIL_FROM_ADDRESS to Render env
- [ ] Add MAIL_FROM_NAME to Render env
- [ ] Wait for Render auto-redeploy
- [ ] Test registration with new account
- [ ] Check email inbox for verification code

## Verification

After setup, you should see in Render logs:
```
[timestamp] Verification code sent: user_id=X, email=test@diu.edu.bd, code=123456
```

If you see:
```
[timestamp] Failed to send verification code email: error=...
```

Then check the error message and fix accordingly.

---

**Once configured, emails will work automatically for:**
- ✅ Registration verification codes
- ✅ Password reset emails
- ✅ Announcement notifications
- ✅ Assignment notifications
