# lab_assignment4_mortage_calculator

A Flutter mortgage calculator app with interactive elements can be built using a StatefulWidget to manage inputs for home price, down payment, interest rate, and loan term, along with radio buttons for interest types and checkboxes for additional fees. The calculation logic utilizes TextField controllers, radio buttons for selecting between fixed/variable rates, and checkboxes for options like "include taxes," updating the result dynamically.

Key Components & Structure
StatefulWidget: Essential for managing the state of inputs (text controllers, radio buttons, checkboxes) and updating the UI when the "Calculate" button is pressed.
TextField: Used for numeric inputs: Home Price, Down Payment (%), Interest Rate (%), and Loan Term (years).
Radio Buttons: Used to select the interest calculation type (e.g., Simple vs. Compound, or Fixed vs. Variable).
Checkbox: Used for optional fees or toggling features (e.g., "Include Property Tax" or "Include Insurance").
ElevatedButton: Triggers the formula: 
Monthly Payment = (P x r(1+r))/((1 + r)n -1))
, where 
P  is principal, 
r is monthly interest rate, and 
n is the total months

steps to Build
Initialize Project: Use flutter create mortgage_app.
UI Design: Use a Scaffold with Column or ListView to layout TextFields for principal/rate/term, RadioListTile for rate type, and CheckboxListTile for extra costs.
State Management: Use setState() to update the UI when users change radio buttons, checkboxes, or input text.
Logic Implementation: Create a function to parse string inputs to doubles, calculate the monthly payment, and format the output.
Display Results: Show the final calculation in a Text widget or a AlertDialog
