# 🚀 Deployment Guide - Rider's Choice

This guide provides step-by-step instructions for deploying the Rider's Choice e-commerce bike showroom app to production.

## 📋 Prerequisites

### Frontend Requirements
- Flutter SDK 3.0+
- Dart SDK
- Xcode (for iOS/macOS builds)
- Android Studio (for Android builds)
- Code signing certificates

### Backend Requirements
- Node.js 16+
- MongoDB database
- Stripe account for payments
- WebSocket server (Socket.io)
- SSL certificate for HTTPS

## 🏗️ Frontend Deployment

### 1. Environment Configuration

Create environment-specific configuration files:

```bash
# lib/core/config/
├── app_config.dart
├── app_config_dev.dart
├── app_config_staging.dart
└── app_config_prod.dart
```

### 2. Build Configuration

Update `pubspec.yaml` for production:

```yaml
name: riders_choice
version: 1.0.0+1
description: Professional E-commerce Bike Showroom

# Add production-specific dependencies
dependencies:
  # ... existing dependencies
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
```

### 3. Build Commands

#### Android APK
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# Split APKs for different architectures
flutter build apk --split-per-abi --release
```

#### Android App Bundle (Recommended)
```bash
flutter build appbundle --release
```

#### iOS
```bash
# Build for iOS
flutter build ios --release

# Archive for App Store
flutter build ipa --release
```

#### macOS
```bash
flutter build macos --release
```

#### Web
```bash
flutter build web --release
```

### 4. Code Signing

#### Android
1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configure `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path to keystore>
```

#### iOS
1. Configure signing in Xcode
2. Set up App Store Connect
3. Configure provisioning profiles

## 🔧 Backend Deployment

### 1. Environment Variables

Create `.env` file:
```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://your-mongodb-uri
JWT_SECRET=your-super-secret-jwt-key
STRIPE_SECRET_KEY=sk_live_your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=whsec_your-webhook-secret
CORS_ORIGIN=https://your-frontend-domain.com
```

### 2. Database Setup

```bash
# Connect to MongoDB
mongo your-mongodb-uri

# Create database
use riders_choice

# Create collections
db.createCollection('users')
db.createCollection('bikes')
db.createCollection('orders')
db.createCollection('payments')
```

### 3. Server Deployment

#### Using PM2 (Recommended)
```bash
# Install PM2
npm install -g pm2

# Start the application
pm2 start server.js --name "riders-choice-api"

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
```

#### Using Docker
```dockerfile
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

```bash
# Build Docker image
docker build -t riders-choice-api .

# Run container
docker run -p 3000:3000 --env-file .env riders-choice-api
```

### 4. WebSocket Server

Configure WebSocket server for production:

```javascript
// server.js
const io = require('socket.io')(server, {
  cors: {
    origin: process.env.CORS_ORIGIN,
    methods: ["GET", "POST"]
  },
  transports: ['websocket', 'polling']
});
```

## 🌐 Domain & SSL Setup

### 1. Domain Configuration
- Point domain to your server IP
- Configure DNS records
- Set up subdomains if needed

### 2. SSL Certificate
```bash
# Using Let's Encrypt
sudo apt-get install certbot
sudo certbot certonly --standalone -d your-domain.com

# Configure Nginx
server {
    listen 443 ssl;
    server_name your-domain.com;
    
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## 📊 Monitoring & Analytics

### 1. Application Monitoring
```bash
# Install monitoring tools
npm install -g pm2-web-interface

# Setup monitoring dashboard
pm2 web
```

### 2. Log Management
```javascript
// Configure Winston for logging
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

### 3. Performance Monitoring
- Set up Firebase Analytics
- Configure crash reporting
- Monitor API response times
- Track user engagement metrics

## 🔒 Security Checklist

### Frontend Security
- [ ] Enable code obfuscation
- [ ] Implement certificate pinning
- [ ] Secure API key storage
- [ ] Enable HTTPS only
- [ ] Implement app integrity checks

### Backend Security
- [ ] Input validation and sanitization
- [ ] Rate limiting
- [ ] CORS configuration
- [ ] JWT token expiration
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] CSRF protection

### Database Security
- [ ] Database encryption at rest
- [ ] Network access restrictions
- [ ] Regular security updates
- [ ] Backup encryption
- [ ] Access logging

## 📱 App Store Deployment

### Google Play Store
1. Create developer account
2. Upload signed APK/AAB
3. Configure store listing
4. Set up pricing and distribution
5. Submit for review

### Apple App Store
1. Create developer account
2. Upload IPA through Xcode
3. Configure App Store Connect
4. Set up app metadata
5. Submit for review

## 🔄 CI/CD Pipeline

### GitHub Actions Example
```yaml
name: Deploy Rider's Choice

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release

  deploy-backend:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: npm ci
      - run: npm test
      - run: npm run deploy
```

## 📈 Performance Optimization

### Frontend Optimization
- [ ] Enable R8/ProGuard for Android
- [ ] Optimize images and assets
- [ ] Implement lazy loading
- [ ] Use cached network images
- [ ] Minimize bundle size

### Backend Optimization
- [ ] Database indexing
- [ ] Query optimization
- [ ] Caching strategies
- [ ] CDN implementation
- [ ] Load balancing

## 🚨 Rollback Plan

### Frontend Rollback
```bash
# Revert to previous version
git checkout <previous-tag>
flutter build appbundle --release
# Upload to app stores
```

### Backend Rollback
```bash
# Using PM2
pm2 restart riders-choice-api --update-env

# Using Docker
docker tag riders-choice-api:previous riders-choice-api:latest
docker-compose up -d
```

## 📞 Support & Maintenance

### Monitoring Alerts
- Set up uptime monitoring
- Configure error alerting
- Monitor performance metrics
- Track user feedback

### Regular Maintenance
- [ ] Security updates
- [ ] Dependency updates
- [ ] Database maintenance
- [ ] Performance reviews
- [ ] User feedback analysis

---

**Deployment completed successfully! 🎉**

For support and questions, contact the development team or create an issue in the repository. 