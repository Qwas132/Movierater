# MovieRater

A command-line Java + SQLite application for managing movie viewing habits.

## Prerequisites

| Requirement | Version |
|-------------|---------|
| Java JDK    | 17 or higher |
| SQLite JDBC | `sqlite-jdbc-3.45.1.0.jar` (included in `lib/`) |

> **No Maven or Gradle required.** The only external dependency is the SQLite JDBC driver, which is already included in the `lib/` folder.

---

## Project Structure

```
MovieRater/
├── lib/
│   └── sqlite-jdbc.jar          # SQLite JDBC driver
├── src/main/java/movierater/
│   ├── Main.java                # Entry point & CLI menu
│   ├── DatabaseManager.java     # Schema creation & CSV-based seeding
│   └── MovieRaterService.java   # All 9 business-logic operations
├── compile.sh                   # Linux/macOS build & run script
├── compile.bat                  # Windows build & run script
u251Cu2500u2500 movie_habits.csv             # Dataset: 100 users, 10 movies, 200 records
└── README.md
```

The SQLite database file (`movierater.db`) is created automatically in the working directory on first run.

---

## How to Run

### Linux / macOS

```bash
chmod +x compile.sh
./compile.sh
```

### Windows

```cmd
compile.bat
u251Cu2500u2500 movie_habits.csv             # Dataset: 100 users, 10 movies, 200 records
```

### Manual (any OS)

```bash
# 1. Compile
javac -cp lib/sqlite-jdbc.jar -d out $(find src -name "*.java")

# 2. Run
java -cp "out:lib/sqlite-jdbc.jar" movierater.Main
# On Windows use semicolons:
java -cp "out;lib/sqlite-jdbc.jar" movierater.Main
```

---

## Using the Application

When the program starts it automatically:
1. Creates the SQLite database (`movierater.db`) and the three tables if they do not exist.
2. Seeds 10 sample users, 8 movies, and 25 viewing-habit records.

You are then presented with an interactive menu:

```
┌─────────────────────────────────────────────────┐
│  1. Add a user                                   │
│  2. View viewing habits for a user               │
│  3. Change a movie title                         │
│  4. Delete a ViewingHabit record                 │
│  5. Show mean age of users                       │
│  6. Count users who watched a specific movie     │
│  7. Show total minutes watched (all users)       │
│  8. Count users who watched more than one movie  │
│  9. Add Email column to User table               │
│  L. List all users & movies                      │
│  0. Quit                                         │
└─────────────────────────────────────────────────┘
```

### Functionality Reference

| Option | Description | SQL operation |
|--------|-------------|---------------|
| **1**  | Add a user by entering their age. The new UserID is shown. | `INSERT INTO User` |
| **2**  | Show all viewing habits for a chosen user (movie info + minutes). | `SELECT … JOIN … WHERE UserID = ?` |
| **3**  | Update the title of a movie by MovieID. | `UPDATE Movie SET Title = ?` |
| **4**  | Delete one row from ViewingHabit by (UserID, MovieID). | `DELETE FROM ViewingHabit WHERE …` |
| **5**  | Display the mean age across all users (calculated in SQL). | `SELECT AVG(Age) FROM User` |
| **6**  | Count distinct users who watched any minutes of a chosen movie. | `SELECT COUNT(DISTINCT UserID) … WHERE MovieID = ?` |
| **7**  | Sum of all MinutesWatched by all users (calculated in SQL). | `SELECT SUM(MinutesWatched) FROM ViewingHabit` |
| **8**  | Count users who have watched more than one distinct movie. | Subquery with `HAVING COUNT(DISTINCT MovieID) > 1` |
| **9**  | Add an `Email TEXT` column to the User table (safe to call multiple times). | `ALTER TABLE User ADD COLUMN Email TEXT` |
| **L**  | Convenience: list all users and all movies. | — |
| **0/Q** | Exit the program. | — |

---

## Database Schema

```
User
  UserID  INTEGER  PRIMARY KEY AUTOINCREMENT
  Age     INTEGER  NOT NULL
  Email   TEXT                               ← added by option 9

Movie
  MovieID      INTEGER  PRIMARY KEY AUTOINCREMENT
  Title        TEXT     NOT NULL
  ReleaseYear  INTEGER
  Director     TEXT
  Genre        TEXT

ViewingHabit
  UserID         INTEGER  NOT NULL  FOREIGN KEY → User
  MovieID        INTEGER  NOT NULL  FOREIGN KEY → Movie
  MinutesWatched INTEGER  NOT NULL
  PRIMARY KEY (UserID, MovieID)
```

---

## Design Notes

- **All calculations are performed in SQL**, not Java (mean, sum, count, subqueries).
- Prepared statements are used throughout to prevent SQL injection.
- The `Email` column check uses `pragma_table_info` to avoid errors if option 9 is called twice.
- The `movierater.db` file persists between runs; delete it to reset to sample data.
