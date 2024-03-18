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

