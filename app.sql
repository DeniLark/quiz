DROP TABLE IF EXISTS tests;

DROP TABLE IF EXISTS questions;

DROP TABLE IF EXISTS answers;

CREATE TABLE tests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT
);

CREATE TABLE questions (
  test_id INTEGER,
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  textQuestion TEXT
);

CREATE TABLE answers (
  question_id INTEGER,
  textAnswer TEXT,
  isCorrect NUMERIC
);