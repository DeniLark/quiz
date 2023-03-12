# Quiz
Этот проект - REST API сервер для создания, редактирования, удаления и прохождения учебных тестов.

## Маршруты
```
GET    http://localhost:8080/tests  - получить список тестов
POST   http://localhost:8080/tests - опубликовать тест
GET    http://localhost:8080/tests/1 - получить тест с id = 1
DELETE http://localhost:8080/tests/1 - удалить тест с id = 1
PUT    http://localhost:8080/tests/1 - редактировать тест с id = 1
GET    http://localhost:8080/answer/1 - проверить ответ с id = 1 на правильность
```

## Примеры запросов на js
```javascript
// 1) получить список тестов
fetch("http://localhost:8080/tests")
  .then(res => res.json())
  .then(tests => console.log(tests))


// 2) опубликовать тест
let testExample = {
  title: "New Test",
  questions: [
    {
      textQuestion: "2 + 2",
      answers:
        [{ isCorrect: false, textAnswer: "3" },
        { isCorrect: true, textAnswer: "4" },
        { isCorrect: false, textAnswer: "5" },
        { isCorrect: false, textAnswer: "6" }]
    }
  ]
}

fetch('http://localhost:8080/tests', {
  method: "POST",
  body: JSON.stringify(testExample),
  headers: {
    "Content-type": "application/json; charset=UTF-8",
  },
})
  .then((response) => response.json())
  .then((json) => console.log(json))

// 3) получить тест с id = 1
fetch("http://localhost:8080/tests/1")
    .then(res => res.json())
    .then(test => console.log(test))

// 4) удалить тест с id = 1
fetch("http://localhost:8080/tests/1", {
    method: "DELETE",
    headers: {
      "Content-type": "application/json; charset=UTF-8",
    },
  })
    .then((response) => response.json())
    .then((json) => console.log(json))

// 5) редактировать тест с id = 1
fetch("http://localhost:8080/tests/1", {
  method: "PUT",
  body: JSON.stringify(testExample),
  headers: {
    "Content-type": "application/json; charset=UTF-8",
  },
})
  .then((response) => response.json())
  .then((json) => console.log(json))

// 6) проверить ответ с id = 1 на правильность
fetch("http://localhost:8080/answer/" + idAnswer)
  .then(res => res.json())
  .then(isCorrect => console.log(isCorrect))
```

## Запуск
Перед запуском сервера должны быть установлены:

- [SQLite](https://www.sqlite.org/index.html)
- [Haskell Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/)

Для создания базы данных выполните в терминале:

```
sqlite3 app.db < app.sql
```

Для запуска сервера:
```
stack run
```

## Клиент
Браузерный клиент для данного сервера находится [здесь](https://github.com/DeniLark/quiz-client)