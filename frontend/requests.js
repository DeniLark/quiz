fetch("http://localhost:8080/tests")
  .then(res => res.json())
  .then(tests => {
    const testsHtml = tests.reduce((acc, test) => {
      return (acc +=
        `<button 
          data-testid="${test.testId}"
          data-testtitle="${test.testTitle}" 
          class="test">${test.testId} ${test.testTitle}
        </button>`)
    }, "")
    document.getElementById("tests").innerHTML = testsHtml
  })

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
    .then((json) => console.log(json));
}

// получить тест
function getTest(idTest, modalWindow) {
  let currentQuestion = 0
  const blockQuestionText = modalWindow.querySelector(".test-question")
  const blockAnswers = modalWindow.querySelector(".test-answers")

  const blockCurentNumber = modalWindow.querySelector(".number-current")
  const blockTotalQuestions = modalWindow.querySelector(".number-total")
  const blockErrors = modalWindow.querySelector(".number-error")

  let errorsCount = 0
  let correctCount = 0

  blockErrors.innerHTML = errorsCount

  fetch("http://localhost:8080/tests/" + idTest)
    .then(res => res.json())
    .then(test => {
      showQuestion(test.questions, currentQuestion)

      blockAnswers.addEventListener("click", e => {
        if (e.target.classList.contains("btn-answer")) {
          currentQuestion++
          showQuestion(test.questions, currentQuestion)
        }
      })
    })

  function showQuestion(questions, currentQuestion) {
    if (currentQuestion + 1 >= questions.length) {
      const finishTestMsg =
        `
        <div class="test-finished">
          <h3>Поздравляем!</h3>
          <h4>Вы прошли тест</h4>
          <p>Правильных ответов: 
           <span class="number-correct">${errorsCount}</span>
          </p>
          <p>Неправильных ответов: 
           <span class="number-error-container">${correctCount}</span>
          </p>
        </div>
        `
      blockQuestionText.innerHTML = finishTestMsg
    }

    blockCurentNumber.innerHTML = currentQuestion + 1
    blockTotalQuestions.innerHTML = questions.length

    blockQuestionText.innerHTML = questions[currentQuestion].textQuestion

    let htmlButtons = questions[currentQuestion].answers.reduce((acc, a) => {
      return (acc += `<button class="btn-answer">${a.textAnswer}</button>`)
    }, "")
    blockAnswers.innerHTML = htmlButtons
  }
}
