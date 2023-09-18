# Salon Appointment App

Salon Appointment App is an appointments management app. We help you to see, add, edit and remove appointments.

## Prerequisites

Before you continue, ensure you meet the following requirements:

- You have installed dart sdk:

  ```
  environment:
      sdk: '>=2.19.0-467.0.dev <4.0.0'
  ```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## UI

- [x] UI Splash Screen
- [x] UI Login Screen
- [x] UI Calendar Screen
- [x] UI Appointment Screen
- [x] UI Appointment Form
- [x] UI Profile Screen

## Features

- [x] UX Login Screen
- [x] UX Calendar Screen
- [x] UX Appointment Screen
- [x] UX New Appointment Screen
- [x] UX Edit Appointment Screen
- [x] UX Profile Screen

## Installation

1. Clone the repository:

   ```
   git clone https://gitlab.asoft-python.com/lan.tran/salon-appointment.git
   ```

2. Checkout branch:

   ```
   git checkout -b flutter_practice
   ```

3. Pull origin branch:

   ```
   git pull origin flutter_practice
   ```

## How to run

- Open terminal: input <kbd>**flutter run**</kbd>

## Overview

- This document provides the requirement for UI and Navigation Flutter.
- Design: [Figma](https://www.figma.com/file/5O9iCeIYYBPFWTgtyM88Dc/beauty-salon-appointments-app?node-id=0-48&t=30zxyqbUUlST4RnU-0)

## Technical

- [Dart](https://dart.dev/)
- [Flutter](https://flutter.dev/)
- [Table Calendar](https://pub.dev/packages/table_calendar)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [http](https://pub.dev/packages/http)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [intl](https://pub.dev/packages/intl)
- [equatable](https://pub.dev/packages/equatable)
- flutter_test
- [bloc_test](https://pub.dev/packages/bloc_test)
- [mocktail](https://pub.dev/packages/mocktail)

## How to run tests

- Open terminal:
  - input <kbd>**flutter test --coverage**</kbd> to run test coverage
  - input <kbd>**perl /c/ProgramData/chocolatey/lib/lcov/tools/bin/genhtml coverage/lcov.info -o coverage/html**</kbd> to generate coverage html file
  - input <kbd>**coverage/html/index.html**</kbd> to open html file
- Run html file with browser
