# 📚 Quiz Proctoring System

## Project Overview

The **Quiz Proctoring System** is a Prolog-based program designed to efficiently assign TAs to proctor quizzes while adhering to their teaching schedules and day-offs. This system ensures quizzes have the required number of proctors without conflicting with their teaching responsibilities.

## Features

- 🗓️ Assign TAs to quizzes considering their teaching schedules and days off.
- 🔄 Verify proctor assignments and check for possible valid assignments.
- 📊 Generate schedules indicating which TAs are available for each quiz slot.

## Predicates

- **`assign_proctors/4`**: Assigns TAs to quizzes while satisfying all constraints.
- **`free_schedule/3`**: Computes the availability of TAs based on their teaching schedules and days off.
- **`assign_quizzes/3`**: Matches quizzes with available TAs ensuring all constraints are met.
- **`assign_quiz/3`**: Provides a list of TAs available to proctor a specific quiz.
