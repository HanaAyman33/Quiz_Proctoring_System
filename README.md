# 📚 Quiz Proctoring System

## Project Overview

The **Quiz Proctoring System** is a Prolog-based program designed to efficiently assign TAs to proctor quizzes while adhering to their teaching schedules and day-offs. This system ensures that quizzes are adequately staffed with the required number of proctors, avoiding conflicts with teaching responsibilities. It provides an optimized and reliable way to manage proctor assignments in an educational setting.

## Features

- 🗓️ **Dynamic Proctor Assignment**: Assign TAs to quizzes while respecting their teaching schedules and days off, ensuring fairness and balance.
- 🔄 **Validation of Assignments**: Automatically verify proctor assignments and identify possible valid configurations.
- 📊 **Schedule Generation**: Produce detailed schedules showing TA availability for each quiz slot, enhancing planning and coordination.

## Predicates

- **`assign_proctors/4`**: Assigns TAs to quizzes while satisfying all constraints, including availability and scheduling rules.
- **`free_schedule/3`**: Computes the availability of TAs based on their teaching schedules and days off, ensuring no conflicts arise.
- **`assign_quizzes/3`**: Matches quizzes with available TAs, ensuring that all constraints are respected and assignments are valid.
- **`assign_quiz/3`**: Provides a list of TAs who are available to proctor a specific quiz, simplifying the assignment process.

This system streamlines quiz proctoring logistics, saving time and reducing manual scheduling errors.
