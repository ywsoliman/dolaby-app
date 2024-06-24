# Dolaby Application

## Project Description
An m-Commerce application that showcases products from various vendors, allowing authenticated users to add/remove products from their shopping carts and complete their shopping cycle online.

## Project Members:
- ## Youssef Waleed
  - Cupons(Discount code)
  - Shopping Cart
  - Payment
  - Ads
  - Settings
- ## Samuel Adel:
  - Product info
  - Search
  - Favorites
  - Auth
- ## Israa Assem
  - Brands
  - Categories
  - Orders
  - Home Design
 
[Trello](https://trello.com/b/6JMwSBbW/shopify-app)

## Project Features

### Main Screen
The main screen contains three tabs:
- **Home**
- **Categories**
- **Me**

### Home Tab
- **Search & Navigation**:
  - Search for a specific product
  - View favorite products
  - Access shopping cart
- **Display**:
  - Ads
  - Scrollable list of Shops (Brands). Selecting a brand navigates the user to that brand's product screen, with filters for price, best seller, etc.

### Categories Tab
- **Search & Navigation**:
  - Search for a specific product
  - Navigate to favorite products
  - Access shopping cart
- **Display**:
  - Main Categories
  - Sub Categories
- **Filtering**:
  - Products can be filtered by main category or sub-category
  - Products can be displayed by price or grouped by sub-categories

### Me Tab
- **Toolbar Navigation**:
  - Shopping cart
  - Settings
- **User Sections**:
  - If logged in:
    1. Welcome message with user's name
    2. Orders section showing 2 recent orders with a "See more" button
    3. Wish list displaying 4 items with a "See more" button
  - If not logged in:
    - Prompt to sign in/register
    - Restriction on accessing shopping cart and wish list

### Product Display
- Products are displayed in a grid with:
  - Image
  - Price
  - Favorite indicator
- Selecting a product navigates to the product details screen

### Product Details Screen
- Collection of images
- Name
- Available sizes (if any)
- Price
- Rating
- **Actions**:
  - Add to favorites
  - Add to shopping cart (cart badge notification)
  - Navigate to shopping cart, favorites, or home

### Shopping Cart Screen
- Products displayed in a list with:
  - Image
  - Name
  - Price
- **Options**:
  - Delete product
  - Increase/decrease item quantity (stock & business logic restricted)
  - Proceed to checkout
- **Price Adjustment**:
  - Total price updates based on user actions

### Settings Screen
- **Settings**:
  - Currency exchange rate (API)
  - Textual address and allowing location provider
  - Add/Delete an address
  - Log out option

### Checkout Process
- **Payment Methods**:
  - Cash on Delivery (with upper limit)
  - Other online payments (Apple Pay)
- **Payment Confirmation**:
  - Confirm payment info
  - Apply discount coupons
- **Order Confirmation**:
  - Send confirmation email with order summary

