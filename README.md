<p>
  <img src="https://github.com/user-attachments/assets/4de2f407-57f3-48b8-8ad8-645805a176dc" alt="Bufflo Logo" width="120" />
</p>

<h1>Bufflo</h1>

<p>
  🧮 A simple and efficient food sales calculator and sales recap tool designed for small food businesses.
</p>

---

## 📸 Preview

<p>
  <img src="https://github.com/user-attachments/assets/802b6411-a6ff-4488-bb5e-bf7ee6f795b7" alt="Bufflo App Preview" width="600"/>
</p>

---

## 📱 About Bufflo

**Bufflo** is a SwiftUI-based mobile app that helps food vendors quickly calculate sales and generate daily or periodic recaps with ease.

Whether you're running a food stall, pop-up, or small eatery, Bufflo helps you track what’s sold and how much revenue you’ve made — all in a lightweight, easy-to-use app.

---

## ✨ Features

- 📦 Add and organize regular and additional food items
- 🧾 Save orders with date and item details
- 📊 Generate daily sales recaps
- 💾 Powered by SwiftData for local persistence
- 🧮 Clean and intuitive UI for quick input and summaries

---

## 🧩 Tech Stack

- **SwiftUI** – Modern declarative UI framework by Apple  
- **SwiftData** – Native data persistence solution  
- **MVVM Architecture** – For clean separation of UI and data logic  

---

## 🗂️ Data Models

### `Order`
| Property | Type       | Description           |
|----------|------------|-----------------------|
| `id`     | UUID       | Unique identifier     |
| `date`   | Date       | Date of the order     |
| `items`  | [OrderItem]| Items in this order   |

### `OrderItem`
| Property   | Type     | Description            |
|------------|----------|------------------------|
| `name`     | String   | Item name              |
| `price`    | Double   | Price per item         |
| `quantity` | Int      | Quantity ordered       |

---

## 👩‍💻 Authors
- Jessica @bolakecil
- Azmi @Azmi1180
- Theodora @Lufiera

---

Built with ❤️ in Apple Developer Academy @BINUS.
