## App Overview

### Summary  
This app is a recipe discovery tool built with SwiftUI and a custom coordinator-based navigation system. It allows users to browse a list of recipes, view detailed instructions, and navigate smoothly between views.  
Screenshots or a short video walkthrough should be included here to highlight the core user flow and features.

---

## Focus Areas

I focused heavily on building a scalable navigation structure using the Coordinator Pattern. This approach keeps navigation logic separate from the views, which makes the app easier to maintain and expand. I also prioritized keeping the UI clean and responsive using SwiftUI's latest features like `NavigationStack` with path-based routing.

---

## Time Spent

I spent approximately 1 hour on this project. Here's how the time was roughly divided:

- Setting up core navigation and coordinators: 1 hour  
- Building the recipe list and detail views: 1hour 
- State management and debugging: 2 hours  
- UI polish and iteration: 1 hour

---

## Trade-offs and Decisions

I chose not to implement data persistence (e.g., Core Data or local storage) in this version to keep the scope focused on architecture and navigation. Additionally, I avoided third-party libraries to keep the project lightweight and easier to review.

---

## Weakest Part of the Project

The app doesn’t currently support offline access or persistent favorites. This is an area I'd focus on improving with more time, likely by integrating local storage or caching strategies.

---

## Additional Information

- The project uses SwiftUI and is structured using the Coordinator Pattern for clear separation of concerns.
- Built and tested with Xcode 15, targeting iOS 17.
- Future improvements could include offline support, favorites/bookmarks, and basic analytics or usage tracking.
