# Rider's Choice Backend

## API Documentation

### Authentication Endpoints
- POST /api/v1/auth/register - User registration
- POST /api/v1/auth/login - User login
- GET /api/v1/auth/profile - Get user profile

### Product Endpoints
- GET /api/v1/package - Get all products
- GET /api/v1/package/:id - Get product by ID
- POST /api/v1/package - Create new product (admin)
- PUT /api/v1/package/:id - Update product (admin)
- DELETE /api/v1/package/:id - Delete product (admin)

### Booking Endpoints
- POST /api/v1/bookings - Create booking
- GET /api/v1/bookings - Get all bookings
- PUT /api/v1/bookings/:id/status - Update booking status

### Review Endpoints
- POST /api/v1/reviews - Create review
- GET /api/v1/reviews - Get all reviews

## Environment Variables
- MONGODB_URI
- JWT_SECRET
- PORT

## Installation
```bash
npm install
npm start
```
