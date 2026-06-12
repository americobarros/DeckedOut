<h1 align="center">
  <img src="https://github.com/user-attachments/assets/6de3f8a7-fedf-42da-a814-64b3b0210c38" alt="card-games-for-imessage" width="64" height="64" align="absmiddle" /> &nbsp; Card Games for iMessage
</h1>

**Card Games for iMessage** is a standalone iMessage application that brings classic, asynchronous card games directly into iOS text threads and group chats. Designed to eliminate the friction of account creation and context switching, the app leverages the Messages framework to deliver a continuous, turn-based gameplay experience natively within the user's messaging environment.

## Technical Architecture

<img align="right" height="254" alt="CGFI_MainMenu" src="https://github.com/user-attachments/assets/613ec8ca-6c39-4b70-8b9d-36ea702ba504" />

* **Application Type:** Standalone iMessage App Extension (No iOS host app required).
* **UI Framework:** Built entirely with **SwiftUI**, ensuring responsive and adaptable layouts across different device sizes and presentation styles (compact vs. expanded).
* **State Management:** Uses `MSMessagesAppViewController` and `MSMessage` to handle payload serialization, URL encoding, and asynchronous turn-based state updates between users.
* **Monetization:** No ads. All included games are available for free. Optional purchasable card backs are offered via Apple's **StoreKit**.

## Included Games

* **Gin Rummy:** Implements standard straight Gin logic when playing with 7 cards or in group chat games, with deadwood calculation in 1v1 10-card hand games.
* **Crazy 8s:** 8s are wild, 2s make the opponent draw 2, Queens skip, and Aces reverse the direction of play.
* **Golf:** Aim to get a low score with a six-card grid.

## Localization & Accessibility

* **Global Reach:** Fully localized across 18 languages! (optimized for Left-to-Right layouts to ensure UI stability).
* **Inclusive Design:** Engineered with Apple's accessibility standards in mind. Includes full **VoiceOver** & **Voice Control** compatibility for addressing individual cards and game elements, **Dynamic Text Sizing**, and **Reduced Motion** during animations.

---

*Your seat at the table is ready!*
