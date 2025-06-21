# Rider's Choice Backend API

A Node.js/Express backend API for the Rider's Choice motorcycle marketplace application.

## Features

- User authentication (JWT)
- Motorcycle CRUD operations
- Order management
- User profiles and wishlists
- RESTful API design
- MongoDB database integration

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or cloud instance)
- npm or yarn

## Installation

1. Clone the repository and navigate to the backend folder:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create environment file:
```bash
cp env.example .env
```

4. Update the `.env` file with your configuration:
```env
MONGODB_URI=mongodb://localhost:27017/riders-choice
JWT_SECRET=your-super-secret-jwt-key
PORT=5000
NODE_ENV=development
```

## Database Setup

1. Make sure MongoDB is running on your system
2. Seed the database with sample data:
```bash
npm run seed
```

This will create:
- Sample motorcycles
- Admin user: admin@riderschoice.com / admin123
- Regular user: john@example.com / user123

## Running the Application

### Development Mode
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get user profile (protected)

### Motorcycles
- `GET /api/bikes` - Get all motorcycles
- `GET /api/bikes/featured` - Get featured motorcycles
- `GET /api/bikes/:id` - Get motorcycle by ID
- `GET /api/bikes/category/:category` - Get motorcycles by category
- `POST /api/bikes` - Add new motorcycle (admin only)
- `PUT /api/bikes/:id` - Update motorcycle (admin only)
- `DELETE /api/bikes/:id` - Delete motorcycle (admin only)
- `POST /api/bikes/:id/reviews` - Add review to motorcycle

### Orders
- `GET /api/orders` - Get user orders (protected)
- `POST /api/orders` - Create new order (protected)

### Health Check
- `GET /api/health` - API health status

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| MONGODB_URI | MongoDB connection string | mongodb://localhost:27017/riders-choice |
| JWT_SECRET | JWT secret key | your-secret-key |
| PORT | Server port | 5000 |
| NODE_ENV | Environment | development |

## Project Structure

```
backend/
├── src/
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/          # MongoDB models
│   ├── routes/          # API routes
│   ├── seed/            # Database seeding
│   └── server.js        # Main server file
├── package.json
├── env.example
└── README.md
```

## Testing the API

You can test the API using tools like Postman, curl, or any HTTP client.

Example requests:

### Register a new user
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'
```

### Get featured bikes
```bash
curl http://localhost:5000/api/bikes/featured
```

### Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"user123"}'
```

## Deployment

1. Set up environment variables for production
2. Use a process manager like PM2
3. Set up a reverse proxy (nginx)
4. Use a cloud MongoDB service (MongoDB Atlas)

## License

ISC 