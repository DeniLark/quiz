getTests()

// получить тесты
function getTests() {
  fetch("http://localhost:8080/tests")
    .then(res => res.json())
    .then(tests => {
      const testsHtml = tests.reduce((acc, test) => {
        return (acc +=
          `<div class="card test">
            <div class="card-body">
              <a 
                href="#" class="link-primary test"
                data-testid="${test.testId}"
                data-testtitle="${test.testTitle}">
                  ${test.testId} ${test.testTitle}
              </a>
              <div class="card-buttons">
                <button data-edittestid="${test.testId}" class="btn btn-outline-primary card-small-btn btn-card_edit">
                  <span data-edittestid="${test.testId}" class="material-symbols-sharp card-small-btn_icon">
                    edit
                  </span></button>
                <button data-deletetestid="${test.testId}" class="btn btn-outline-primary card-small-btn btn-card_edit">
                  <span data-deletetestid="${test.testId}" class="material-symbols-sharp card-small-btn_icon">
                    delete
                  </span>
                </button>
              </div>
            </div>
          </div>`)
      }, "")
      document.getElementById("tests").innerHTML = testsHtml
    })
}

// Отправить тест
function submitTest(test) {
  fetch('http://localhost:8080/tests', {
    method: 'POST',
    body: JSON.stringify(test),
    headers: {
      'Content-type': 'application/json; charset=UTF-8',
    },
  })
    .then((response) => response.json())
    .then((json) => {
      getTests()
      alert("Тест опубликован.")
    });
}

// Удалить тест
function deleteTest(idTest) {
  fetch('http://localhost:8080/tests/' + idTest, {
    method: "DELETE",
    headers: {
      'Content-type': 'application/json; charset=UTF-8',
    },
  })
    .then((response) => response.json())
    .then((json) => {
      if (json) {
        getTests()
        alert("Тест удален")
      }
    });
}

// получить тест, и пройти его
function getTest(idTest, modalWindow) {
  let currentQuestion = 0
  let errorsCount = 0
  let correctCount = 0

  const blockQuestionText = modalWindow.querySelector(".test-question")
  const blockAnswers = modalWindow.querySelector(".test-answers")

  const blockInfo = modalWindow.querySelector(".block-info")
  const blockCurentNumber = modalWindow.querySelector(".number-current")
  const blockTotalQuestions = modalWindow.querySelector(".number-total")
  const blockErrors = modalWindow.querySelector(".number-error")

  blockInfo.classList.remove("block-info_hidden")

  fetch("http://localhost:8080/tests/" + idTest)
    .then(res => res.json())
    .then(test => {
      showQuestion(test.questions, currentQuestion)

      blockAnswers.addEventListener("click", blockAnswersHandler)

      function blockAnswersHandler(e) {
        if (e.target.classList.contains("btn-answer")) {
          const idAnswer = e.target.dataset.answer

          fetch("http://localhost:8080/answer/" + idAnswer)
            .then(res => res.json())
            .then(isCorrect => {
              isCorrect ? correctCount++ : errorsCount++
              currentQuestion++
              if (currentQuestion + 1 > test.questions.length) {
                const finishTestMsg =
                  `
                  <div class="test-finished">
                    <h3>Поздравляем!</h3>
                    <h4>Вы прошли тест</h4>
                    <p>Правильных ответов:
                      <span class="number-correct">${correctCount}</span>
                    </p>
                    <p>Неправильных ответов:
                      <span class="number-error-container">${errorsCount}</span>
                    </p>
                  </div>
                  `
                blockQuestionText.innerHTML = finishTestMsg
                blockAnswers.innerHTML = ""
                blockInfo.classList.add("block-info_hidden")
                blockAnswers.removeEventListener("click", blockAnswersHandler)
              } else showQuestion(test.questions, currentQuestion)
            })
        }
      }
    })

  function showQuestion(questions, currentQuestion) {
    console.log(currentQuestion, questions.length)

    blockCurentNumber.innerHTML = currentQuestion + 1
    blockTotalQuestions.innerHTML = questions.length
    blockErrors.innerHTML = errorsCount

    blockQuestionText.innerHTML = questions[currentQuestion].textQuestion

    let htmlButtons = questions[currentQuestion].answers.reduce((acc, a) => {
      return (acc += `<button data-answer="${a.answerId}" 
                              class="btn-answer btn btn-outline-dark">
                        ${a.textAnswer}
                      </button> `)
    }, "")
    blockAnswers.innerHTML = htmlButtons
  }
}
