# AR Kindergarten Education App (WIP)

A multi-platform Augmented Reality (AR) application designed for kindergarteners to interact with 3D educational content, videos, and digital books via QR code tracking. 

**Note:** This project is currently a **Work in Progress**. Core AR mechanics and backend services are functional, while platform-specific integration and progress tracking are in active development.

---

## 🚀 System Architecture

This project utilizes a sophisticated multi-tier architecture to bridge native mobile frameworks with Unity AR and a dual-backend system.

### **Tech Stack**
* **Frontend (Native):** UIKit (iOS) & Kotlin (Android)
* **AR Engine:** Unity 3D with Vuforia Engine & AR Foundation
* **Vision Server:** Python (Flask + OpenCV) for real-time QR tracking and data relay
* **Data Server:** Node.js (Express) with MySQL for authentication and user records

---

## 🛠 Project Status & Current Progress

### **1. Augmented Reality (Unity & Vuforia)**
- [x] Integration of Vuforia Engine for image/QR recognition.
- [x] Basic 3D model rendering upon target detection.
- [x] Functional Video and Book content display within the AR view.
- [ ] Smooth transition/handshake between Native UI and Unity View.

### **2. Mobile Platforms**
- **iOS (UIKit):**
    - [x] UI/UX Design for login and navigation dashboards complete.
    - [ ] Integration with Unity as a Library (UaaL) is currently **pending**.
- **Android (Kotlin):**
    - [x] User Login functionality fully operational.
    - [ ] Main Dashboard and learner UI are currently **placeholders**.

### **3. Backend & Logic**
- [x] **Python Vision Server:** OpenCV-based QR tracking logic and Flask API communication.
- [x] **Node.js Server:** RESTful API for user authentication and session management.
- [x] **MySQL Database:** Schema for user credentials and progress records.
- [ ] **Progress Tracker:** Logic for saving/retrieving achievement milestones is **unfinished**.

---

## 🔧 Installation & Setup

1.  **Unity:** Requires Unity 202x.x and the Vuforia Engine package.
2.  **Backend:** - Run the Node.js server (`npm start`) for authentication.
    - Run the Python script for the CV-based tracking server.
3.  **Mobile:** - iOS requires CocoaPods installation.
    - Android requires SDK 31+ and Kotlin 1.9+.

---
