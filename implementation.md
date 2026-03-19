**PakSaver**

Smart Budget Tracker for Pakistanis

Complete Flutter Implementation Plan

This document contains step-by-step prompts to give to an AI (like
Claude) to build the entire PakSaver app from scratch. Follow each phase
in order. Do not skip steps.

**Project Overview**

PakSaver is a simple offline budget tracking app built for Pakistani
users. It uses PKR as currency, has local Pakistani expense categories,
and stores all data on the device --- no internet required. The app is
intentionally simple and beginner-level.

**Tech Stack**

  ----------------------------- ---------------------- -------------------------
  **Technology**                **Purpose**            **Why this choice**

  Flutter (Dart)                Mobile app framework   Cross-platform, one
                                                       codebase

  Hive                          Local database         Simple, fast, no server
                                                       needed

  Provider                      State management       Beginner-friendly,
                                                       lightweight

  fl_chart                      Pie & bar charts       Easy to use, looks clean

  flutter_local_notifications   Budget alerts          Simple notification
                                                       package
  ----------------------------- ---------------------- -------------------------

**Target Screens**

-   Splash Screen --- App logo and name

-   Onboarding Screen --- Set monthly budget in PKR (shown only first
    time)

-   Home Dashboard --- Shows balance, total spent, remaining budget

-   Add Expense Screen --- Enter amount, pick category, add optional
    note

-   History Screen --- List of all expenses, filter by month

-   Charts Screen --- Pie chart by category, bar chart by month

-   Settings Screen --- Change budget, toggle dark mode

**Pakistani Expense Categories**

  ----------------------- ----------------------- -----------------------
  **Category Name**       **Urdu Label**          **Emoji**

  Rashan                  راشن                    🛒

  Bijli (Electricity)     بجلی                    💡

  Gas Bill                گیس بل                  🔥

  Internet                انٹرنیٹ                 📶

  Transport (Safar)       سفر                     🚗

  Mobile Balance          موبائل بیلنس            📱

  Medical                 طبی                     💊

  Education               تعلیم                   📚

  Eating Out              باہر کھانا              🍽️

  Clothes                 کپڑے                    👕

  Rent                    کرایہ                   🏠

  Other                   دیگر                    📦
  ----------------------- ----------------------- -----------------------

**Phase 1 --- Project Setup**

*Time estimate: 30 minutes*

**Step 1.1 --- Create Flutter Project**

Give this exact prompt to the AI:

  -----------------------------------------------------------------------
  Create a new Flutter project called \"paksaver\". Set up the folder
  structure like this:

  lib/

  main.dart

  models/

  expense.dart

  screens/

  splash_screen.dart

  onboarding_screen.dart

  home_screen.dart

  add_expense_screen.dart

  history_screen.dart

  charts_screen.dart

  settings_screen.dart

  widgets/

  expense_card.dart

  category_chip.dart

  providers/

  expense_provider.dart

  utils/

  categories.dart

  constants.dart

  Just create empty files with basic placeholder content for now. Do not
  write any logic yet.
  -----------------------------------------------------------------------

**Step 1.2 --- pubspec.yaml Dependencies**

Give this prompt to the AI:

  -----------------------------------------------------------------------
  Update my pubspec.yaml to add these dependencies exactly. Do not add
  any other packages:

  dependencies:

  flutter:

  sdk: flutter

  hive: \^2.2.3

  hive_flutter: \^1.1.0

  provider: \^6.1.1

  fl_chart: \^0.68.0

  flutter_local_notifications: \^17.0.0

  shared_preferences: \^2.2.2

  intl: \^0.19.0

  dev_dependencies:

  hive_generator: \^2.0.1

  build_runner: \^2.4.7

  After updating, also write the terminal commands I need to run to
  install these packages.
  -----------------------------------------------------------------------

**Step 1.3 --- App Constants & Categories**

Give this prompt to the AI:

  -----------------------------------------------------------------------
  Write the code for lib/utils/categories.dart and
  lib/utils/constants.dart.

  In categories.dart, create a list called \'pakCategories\' with these
  categories as a List\<Map\>.

  Each map should have: name (String), urdu (String), emoji (String),
  color (Color).

  Categories: Rashan, Bijli, Gas Bill, Internet, Safar, Mobile Balance,

  Medical, Education, Eating Out, Clothes, Rent, Other.

  Use simple solid colors from Material palette --- green, blue, orange
  etc.

  In constants.dart, create:

  \- const String kBudgetKey = \'monthly_budget\'

  \- const String kThemeKey = \'is_dark_mode\'

  \- const String kOnboardingKey = \'onboarding_done\'

  \- const Color kPrimaryColor = Color(0xFF1A5276)

  \- const Color kAccentColor = Color(0xFF2874A6)

  Keep it simple. No fancy logic.
  -----------------------------------------------------------------------

**Phase 2 --- Data Model & Database**

*Time estimate: 45 minutes*

**Step 2.1 --- Expense Model (Hive)**

Give this prompt to the AI:

  -----------------------------------------------------------------------
  Write the Expense model in lib/models/expense.dart using Hive.

  The Expense class should have these fields:

  \- id: String (use DateTime.now().toString() as id)

  \- amount: double (the money amount in PKR)

  \- category: String (category name like \'Rashan\')

  \- categoryEmoji: String (the emoji for that category)

  \- note: String (optional description, can be empty)

  \- date: DateTime (when the expense was added)

  Use \@HiveType(typeId: 0) and \@HiveField annotations.

  Also write the ExpenseAdapter --- the full generated adapter code.

  I am a beginner so please add comments explaining what each part does.

  Also write the Hive initialization code that goes in main.dart,

  including Hive.initFlutter() and registering the adapter.
  -----------------------------------------------------------------------

**Step 2.2 --- Expense Provider**

Give this prompt to the AI:

  -----------------------------------------------------------------------
  Write the ExpenseProvider class in lib/providers/expense_provider.dart.

  Use the Provider package. Keep it simple for a beginner project.

  The provider should have:

  \- List\<Expense\> \_expenses (private list from Hive box)

  \- double monthlyBudget (loaded from SharedPreferences)

  \- bool isDarkMode (loaded from SharedPreferences)

  Methods to include:

  \- loadData() --- loads expenses from Hive + budget from
  SharedPreferences

  \- addExpense(Expense e) --- saves to Hive and updates list

  \- deleteExpense(String id) --- removes from Hive by id

  \- setBudget(double amount) --- saves to SharedPreferences

  \- toggleDarkMode() --- toggles and saves theme preference

  Also add these getters:

  \- totalSpentThisMonth --- sum of this month\'s expenses

  \- remainingBudget --- monthlyBudget minus totalSpentThisMonth

  \- expensesByCategory --- Map\<String, double\> for chart data

  \- expensesByMonth --- Map\<String, double\> last 6 months for bar
  chart

  Add comments on every method. Use notifyListeners() after any data
  change.
  -----------------------------------------------------------------------

**Phase 3 --- Screens (Build One by One)**

*Time estimate: 3--4 hours total*

**IMPORTANT: Build and test each screen separately. Do not ask for all
screens at once.**

**Step 3.1 --- main.dart & App Entry**

  -----------------------------------------------------------------------
  Write the complete main.dart for PakSaver.

  It should:

  1\. Initialize Hive with initFlutter()

  2\. Register ExpenseAdapter

  3\. Open a Hive box called \'expenses\'

  4\. Wrap the app with ChangeNotifierProvider\<ExpenseProvider\>

  5\. Call provider.loadData() on startup

  6\. Check SharedPreferences for \'onboarding_done\' key

  \- If false: show OnboardingScreen as first screen

  \- If true: show HomeScreen as first screen

  7\. Support dark mode based on isDarkMode from provider

  Use MaterialApp. Keep the theme simple --- just primary color #1A5276.

  Use SplashScreen as the initial route that then navigates to the right
  screen.

  Add comments explaining the startup flow.
  -----------------------------------------------------------------------

**Step 3.2 --- Splash Screen**

  -----------------------------------------------------------------------
  Write lib/screens/splash_screen.dart for PakSaver.

  Design requirements:

  \- Show the app name \'PakSaver\' in large bold text

  \- Show a small tagline below: \'Apka Budget, Apki Marzi\'

  \- Show a simple rupee sign icon (just use Text with Rs symbol, size
  60)

  \- Background color: #1A5276 (dark blue)

  \- All text in white

  \- After 2 seconds, navigate to the correct screen

  (check SharedPreferences for onboarding_done)

  Keep it very simple. No animations. Just a centered Column with the
  logo and text.

  I am a beginner so do not use fancy packages.
  -----------------------------------------------------------------------

**Step 3.3 --- Onboarding Screen**

  -----------------------------------------------------------------------
  Write lib/screens/onboarding_screen.dart for PakSaver.

  This screen shows only once when the user first installs the app.

  Design requirements:

  \- Title: \'Welcome to PakSaver!\'

  \- Subtitle: \'Set your monthly budget in PKR to get started\'

  \- A TextField for entering the budget amount (numbers only, PKR)

  \- A big green button: \'Start Saving\'

  \- When button pressed: save the budget using provider.setBudget()

  then save \'onboarding_done = true\' to SharedPreferences

  then navigate to HomeScreen (and remove onboarding from stack)

  Keep the UI simple: white background, centered content, basic padding.

  Show a validation message if user tries to continue without entering
  amount.

  No fancy animations. Just a clean simple form.
  -----------------------------------------------------------------------

**Step 3.4 --- Home Dashboard Screen**

  -----------------------------------------------------------------------
  Write lib/screens/home_screen.dart for PakSaver.

  This is the main screen with a BottomNavigationBar with 4 tabs:

  Tab 0: Home (house icon)

  Tab 1: Add Expense (add icon) --- opens AddExpenseScreen

  Tab 2: History (list icon)

  Tab 3: Charts (pie chart icon)

  The Home tab body should show:

  \- A top card with blue background (#1A5276) showing:

  \* \'Monthly Budget\' label

  \* The budget amount in PKR (e.g., Rs. 30,000)

  \* \'Spent: Rs. X\' in smaller text

  \* \'Remaining: Rs. X\' in smaller text

  \* A simple LinearProgressIndicator showing spent/budget ratio

  (red if over 80%, green otherwise)

  \- Below the card: a ListView of the last 5 expenses

  with a heading \'Recent Expenses\'

  Each item shows: emoji + category name + amount + date

  \- A FloatingActionButton (+ icon) that navigates to AddExpenseScreen

  \- An AppBar with title \'PakSaver\' and a settings icon that

  navigates to SettingsScreen

  Use Consumer\<ExpenseProvider\> to read data.

  Keep the design simple --- standard Flutter widgets only.
  -----------------------------------------------------------------------

**Step 3.5 --- Add Expense Screen**

  -----------------------------------------------------------------------
  Write lib/screens/add_expense_screen.dart for PakSaver.

  This screen lets the user add a new expense.

  Fields:

  1\. Amount field --- TextField, numbers only, shows \'Rs.\' prefix

  2\. Category picker --- a Wrap of category chips

  Show each category as a chip: emoji + name

  Selected category chip highlights in blue

  Use the pakCategories list from categories.dart

  3\. Note field --- TextField, optional, hint: \'Add a note (optional)\'

  4\. Date --- show today\'s date as text, with a small calendar icon

  Tapping it opens DatePicker so user can change the date

  5\. A big \'Save Expense\' button at the bottom

  On save:

  \- Validate that amount is not empty and category is selected

  \- Create an Expense object and call provider.addExpense()

  \- Check if totalSpentThisMonth \> monthlyBudget \* 0.9

  If yes, show a SnackBar warning: \'You are close to your budget
  limit!\'

  \- Pop back to previous screen

  Keep UI simple: white background, standard Flutter form widgets.

  Use a GlobalKey\<FormState\> for form validation.
  -----------------------------------------------------------------------

**Step 3.6 --- History Screen**

  -----------------------------------------------------------------------
  Write lib/screens/history_screen.dart for PakSaver.

  Shows all expenses in a scrollable list, newest first.

  Features:

  1\. A dropdown at the top to filter by month

  Options: last 6 months by name (e.g., \'March 2025\', \'February
  2025\')

  2\. A ListView.builder showing each expense as a Card:

  \- Left side: colored circle with category emoji

  \- Middle: category name (bold) + note below (grey, smaller)

  \- Right side: \'-Rs. X\' in red + date below in grey

  3\. Swipe left on any card to delete it

  Show a Dismissible widget with red delete background

  Show a confirmation SnackBar with \'Undo\' option

  4\. If no expenses: show a centered text \'No expenses yet!\'

  Keep it straightforward. No complex animations.

  Use Consumer\<ExpenseProvider\> for data.
  -----------------------------------------------------------------------

**Step 3.7 --- Charts Screen**

  -----------------------------------------------------------------------
  Write lib/screens/charts_screen.dart for PakSaver.

  Use the fl_chart package.

  Show two charts, one above the other:

  Chart 1 --- Pie Chart (Spending by Category):

  \- Title: \'This Month by Category\'

  \- Use PieChart from fl_chart

  \- Each slice = one category\'s total spending

  \- Show category emoji + percentage in a legend below the chart

  \- If no expenses: show text \'No data yet\'

  Chart 2 --- Bar Chart (Monthly Spending):

  \- Title: \'Last 6 Months\'

  \- Use BarChart from fl_chart

  \- X axis: month abbreviations (Jan, Feb etc.)

  \- Y axis: amount in PKR

  \- Blue bars, simple design

  \- If no data: show text \'No data yet\'

  Keep the chart configs simple and minimal.

  Wrap in a SingleChildScrollView so both charts are visible.

  Use Consumer\<ExpenseProvider\> to get data.
  -----------------------------------------------------------------------

**Step 3.8 --- Settings Screen**

  -----------------------------------------------------------------------
  Write lib/screens/settings_screen.dart for PakSaver.

  Simple settings page with these options:

  1\. Budget Setting:

  \- Show current monthly budget

  \- A TextField to enter new budget

  \- \'Update Budget\' button that calls provider.setBudget()

  2\. Dark Mode Toggle:

  \- A SwitchListTile labeled \'Dark Mode\'

  \- Calls provider.toggleDarkMode() on change

  3\. About section:

  \- App name: PakSaver

  \- Version: 1.0.0

  \- A small tagline

  Use a simple ListView with ListTile and Card widgets.

  AppBar title: \'Settings\'

  No complex logic needed.
  -----------------------------------------------------------------------

**Phase 4 --- Widgets & UI Polish**

*Time estimate: 1 hour*

**Step 4.1 --- Expense Card Widget**

  -----------------------------------------------------------------------
  Write lib/widgets/expense_card.dart for PakSaver.

  A reusable card widget that displays a single expense.

  Accept an Expense object as parameter.

  Design:

  \- Card with slight elevation (elevation: 2)

  \- Left: a CircleAvatar (radius 24) with the category emoji

  Background color = a light shade based on category

  \- Middle: Column with category name (bold, 15sp) and

  note text below (grey, 12sp, show \'No note\' if empty)

  \- Right: Column with \'-Rs. X,XXX\' in red (bold)

  and date below in grey (12sp, format: \'dd MMM\')

  Format amounts with comma separators using NumberFormat from intl
  package.

  Keep it clean and readable. Standard Flutter widgets only.
  -----------------------------------------------------------------------

**Step 4.2 --- Category Chip Widget**

  -----------------------------------------------------------------------
  Write lib/widgets/category_chip.dart for PakSaver.

  A reusable widget for category selection in the Add Expense screen.

  Parameters:

  \- category: Map (from pakCategories list)

  \- isSelected: bool

  \- onTap: VoidCallback

  Design when NOT selected:

  \- Light grey background

  \- Emoji + category name in dark text

  \- Rounded border (BorderRadius 20)

  Design when IS selected:

  \- Blue background (#1A5276)

  \- Emoji + category name in white

  \- Slight shadow

  Use an InkWell wrapping a Container. Keep it simple.
  -----------------------------------------------------------------------

**Phase 5 --- Notifications & Final Touches**

*Time estimate: 45 minutes*

**Step 5.1 --- Local Notifications Setup**

  -----------------------------------------------------------------------
  Set up flutter_local_notifications in PakSaver.

  Create a file lib/utils/notification_helper.dart with a class
  NotificationHelper.

  Include these methods:

  1\. initialize() --- initializes the plugin, call this in main.dart

  2\. showBudgetAlert(double spent, double budget) ---

  shows a notification with title \'Budget Alert!\'

  and body \'You have spent Rs. X out of Rs. Y this month\'

  Also write the Android manifest changes needed (permissions).

  Keep it simple --- just local notifications, no scheduling needed.

  Add clear comments explaining each step.
  -----------------------------------------------------------------------

**Step 5.2 --- Dark Mode Integration**

  -----------------------------------------------------------------------
  Update main.dart in PakSaver to properly support dark mode.

  In the MaterialApp, use Consumer\<ExpenseProvider\> to read isDarkMode.

  Set themeMode based on isDarkMode:

  \- isDarkMode true: ThemeMode.dark

  \- isDarkMode false: ThemeMode.light

  Create a simple dark theme with these settings:

  \- scaffoldBackgroundColor: Color(0xFF1C2333)

  \- cardColor: Color(0xFF243044)

  \- primaryColor: Color(0xFF2874A6)

  \- textTheme: white text

  Keep the theme minimal. Do not over-style.
  -----------------------------------------------------------------------

**Step 5.3 --- Empty State & Error Handling**

  -----------------------------------------------------------------------
  Add basic empty states and error handling to PakSaver.

  1\. In HomeScreen, if expenses list is empty:

  Show a centered Column with:

  \- Large emoji: 💰

  \- Text: \'No expenses yet!\'

  \- Subtext: \'Tap + to add your first expense\'

  2\. In HistoryScreen, if filtered list is empty:

  Show: \'No expenses for this month\'

  3\. In ChartsScreen, if no data:

  Show: \'Add some expenses to see your charts\'

  4\. Wrap the Hive loadData() in a try-catch and print errors to
  console.

  5\. In AddExpenseScreen, if amount entered is 0 or negative:

  Show error: \'Please enter a valid amount\'

  Keep all error messages friendly and simple.
  -----------------------------------------------------------------------

**Phase 6 --- Testing & GitHub**

*Time estimate: 30 minutes*

**Step 6.1 --- Test the App**

Before publishing, test these things manually on your emulator or phone:

  -------------------------- -------------------------- -----------------
  **Test Case**              **Expected Result**        **Pass/Fail**

  Open app first time        Onboarding screen appears  

  Enter budget and tap Start Home screen opens          

  Add an expense             Appears in home and        
                             history                    

  Spend 90%+ of budget       Warning SnackBar appears   

  Delete an expense          Removed from all screens   

  Toggle dark mode           Whole app changes theme    

  Change monthly budget      Home card updates          

  Charts screen              Shows pie and bar chart    

  Close and reopen app       Data still there (Hive)    

  Filter history by month    Only that month shows      
  -------------------------- -------------------------- -----------------

**Step 6.2 --- GitHub Setup**

  -----------------------------------------------------------------------
  Help me set up a GitHub repository for PakSaver.

  Write a proper README.md for the project with these sections:

  \- Project name and description

  \- Screenshots placeholder section

  \- Features list

  \- Tech stack used

  \- How to run locally (flutter pub get, flutter run)

  \- Folder structure

  Also write a .gitignore file suitable for a Flutter project.

  Make the README look like a beginner wrote it but with proper
  structure.

  Do not use fancy badges or shields. Keep it clean and honest.
  -----------------------------------------------------------------------

**Step 6.3 --- LinkedIn Description**

Use this exact description when adding PakSaver to your LinkedIn
projects section:

+-----------------------------------------------------------------------+
| **PakSaver --- Budget Tracker App (Flutter)**                         |
|                                                                       |
| Built a personal finance app designed specifically for Pakistani      |
| users. The app tracks daily expenses in PKR with local categories     |
| like Rashan, Bijli, and Safar. Features include a monthly budget      |
| system with alerts, expense history with monthly filtering, and       |
| visual spending charts. All data is stored locally using Hive --- no  |
| internet connection needed.                                           |
|                                                                       |
| *Tech used: Flutter, Dart, Hive (local DB), Provider, fl_chart*       |
+-----------------------------------------------------------------------+

**Interview Preparation**

Study these answers before any interview. These are the most common
questions about a Flutter project.

**Common Interview Questions & Answers**

  ------------------------------- ---------------------------------------
  **Question**                    **Your Answer**

  Why did you use Hive instead of Hive is simpler for a beginner and
  SQLite?                         works well for small apps. I did not
                                  need complex SQL queries --- just
                                  storing and reading expense objects.
                                  Hive lets me store Dart objects
                                  directly.

  Why Provider for state          Provider is the officially recommended
  management?                     beginner state management solution by
                                  Flutter team. I considered GetX but it
                                  felt like overkill for this project
                                  size.

  How does the budget alert work? After every expense is saved, I compare
                                  totalSpentThisMonth with monthlyBudget.
                                  If spent exceeds 90%, I show a SnackBar
                                  warning. I also use
                                  flutter_local_notifications for
                                  device-level alerts.

  How is data stored when app     All expense data is saved in a Hive box
  closes?                         on the device storage. Hive is
                                  persistent --- it survives app
                                  restarts. Budget preference is stored
                                  in SharedPreferences.

  What was the hardest part?      Getting the Hive adapter to generate
                                  correctly with build_runner. I also
                                  struggled with the fl_chart pie chart
                                  until I figured out the sections need
                                  percentage values not raw amounts.

  What would you improve?         Add cloud backup using Firebase,
                                  support multiple currencies, add a
                                  recurring expense feature, and maybe
                                  export to PDF. I kept scope small to
                                  finish within 2 weeks.

  How does dark mode work?        I store the isDarkMode boolean in
                                  SharedPreferences. The ExpenseProvider
                                  exposes it and calls notifyListeners().
                                  The MaterialApp reads it and switches
                                  ThemeMode between light and dark.
  ------------------------------- ---------------------------------------

**Code Concepts to Understand**

Make sure you understand these Flutter concepts before the interview:

-   StatelessWidget vs StatefulWidget --- when to use each

-   ChangeNotifier and notifyListeners() --- how Provider works

-   Consumer\<T\> vs context.watch\<T\>() --- same thing, different
    syntax

-   Hive box --- like a Map stored on disk, survives app restart

-   SharedPreferences --- key-value storage for simple settings

-   async/await --- because Hive and SharedPreferences are async

-   Dismissible widget --- enables swipe-to-delete

-   Navigator.push vs Navigator.pushReplacement --- stack vs replace

**Final Checklist Before LinkedIn**

  ----------------------------------------------------- -----------------
  **Task**                                              **Done?**

  All 7 screens working correctly                       ☐

  Data persists after app restart                       ☐

  Budget alert shows when near limit                    ☐

  Charts display correctly                              ☐

  Dark mode toggles properly                            ☐

  App runs without crashes on emulator                  ☐

  Code pushed to GitHub                                 ☐

  README.md written                                     ☐

  Can explain every screen from memory                  ☐

  Added to LinkedIn with correct description            ☐
  ----------------------------------------------------- -----------------

**Good luck Muhammad! Build it, understand it, own it. 💪**