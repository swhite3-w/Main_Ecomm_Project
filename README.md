# ArtForYou – E-Commerce Web Application

ArtForYou is a Ruby on Rails e-commerce application designed to provide a clean and refined shopping experience for browsing and purchasing artwork.

## Features

### User Features
- Browse products by category
- Search and filter products (keyword, category, status)
- View detailed product pages
- Add items to cart
- Update and remove items from cart
- Responsive design for desktop and mobile

### Authentication (3.1.4)
- User registration and login using Devise
- Session management (login/logout)
- Conditional navigation based on authentication state

### Customer Data (3.1.5)
- Customers store:
  - Full name
  - Email
  - Province (for tax calculation)
- Editable account information

### Cart & Checkout
- Dynamic cart with quantity updates
- Subtotal and total calculation
- Province-based tax handling
- Order confirmation flow

### Admin Features
- Admin dashboard (ActiveAdmin)
- Manage products, categories, and orders
- Province tax management

---

## Tech Stack

- Ruby on Rails
- SQLite3
- Devise (authentication)
- ActiveAdmin (admin dashboard)
- SCSS (custom responsive styling)
- Kaminari (pagination)

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/swhite3-w/Main_Ecomm_Project.git
cd Main_Ecomm_Project
```

2. Install dependencies
```bash
bundle install
```

3. Setup database
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Run the server
```bash
rails server
```

Then open:

http://localhost:3000


### Key Pages
Home (product browsing + search)
Category pages (filtered products + pagination)
Product detail page
Cart page (responsive table + mobile layout)
Checkout + order confirmation
Login / Signup / Account management
Admin dashboard

### Design Highlights
Consistent UI across all pages
Custom component-based styling
Mobile responsive layouts:
Navigation collapses vertically
Tables convert to card layouts
Buttons scale to full width
Clean typography and spacing


### Known Limitations
No payment gateway integration (simulation only)
No deployment configured (runs locally)

### Author

Sakaria White
Full-Stack Web Development Student