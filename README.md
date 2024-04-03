# Expense Tracker App

Expense Tracker is a mobile application designed to help users keep track of their expenses conveniently. The app allows users to manage pending and paid expenses efficiently.

## Features

### 1. Pending Expenses (Tab 1)

- This view displays a list of expenses created by the user that are pending to be paid.
- Each item in the list includes:
  - Title
  - Expense creation date
  - Category
  - Expense amount

### 2. Paid Expenses (Tab 2)

- This view shows a list of expenses that the user has already paid.
- Each item in the list includes:
  - Title
  - Category
  - Expense creation date
  - Expense paid date
  - Expense amount

### 3. Create Expense (Standalone View)

- Accessed by tapping the "+" floating icon located at the bottom right corner of the Pending Expense view.
- User provides the following information to create an expense:
  - Title (Free Text)
  - Description (Free Text)
  - Amount (Numeric Value)
  - Category (Free Text)
  - Type (Recurrent / Random) - mutually exclusive options:
    - Recurrent Expense: Automatically repeats every month
    - Random Expense: Does not repeat every month
- After adding an expense, the user is redirected to the Pending Expense view.

### 4. Expense Detail (Standalone View)

- Similar to the Create Expense view, but with pre-populated values.
- User can tap on "Pay Expense" button to mark the expense as paid.
- Status of the expense changes to "Paid".
- User is redirected to the Paid Expense view where they can see the item in the list.

### 5. Settings View (Tab 3)

- The Settings View contains one button titled Category Management.
- Tapping on this button will take the user to the Category Management view.

### 6. Category Management View

- An empty text field with a "+" button on the right side allows users to create a category.
- Users can create a category by typing a category name and tapping on the "+" button.
- Added categories will appear on the list below the text field.
- Categories with similar names are prevented from existing.

### 7. Trend View

- This view includes two dropdown menus at the top:
  1. Month (It includes names of every month).
  2. Year (2000 - Current Year).
- After selecting a month and a year, a bar chart is displayed.
- The chart is plotted against each category of that month, showing the expenses for each category.
- Properly set the maximum value of the Y-axis for the values presented on each month.

## Notes:
1. Ensure that categories with similar names do not exist.
2. The category field while creating an expense is replaced with a drop-down list developed in Assignment 1.
3. Set the maximum value of the Y-axis properly for the values presented on each month.

## Usage

- Pending Expenses: Tab 1
- Paid Expenses: Tab 2
- Create Expense: Accessed via the "+" floating icon
- Expense Detail: Accessed by tapping on an expense item

## Installation

- Clone this repository.
- Navigate to the project directory.
- Open .xcodeproj using XCode

## Support

- XCode 15.0 (or upper)
- iOS 16.0 (or upper)

## Technologies Used

- Swift
- SwiftUI
- CoreData

## Contributors

- Shahwat Hasnaine

