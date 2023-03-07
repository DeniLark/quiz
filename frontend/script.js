document.addEventListener("DOMContentLoaded", () => {
  const modalTest = document.querySelector(".modal-test")
  const modalAddTest = document.querySelector(".modal-add-test")

  const modalTestClose = modalTest.querySelector(".modal-btn_close")

  const modalAddTestClose = modalAddTest.querySelector(".modal-btn_close")
  const btnAddQuestion = modalAddTest.querySelector("#btn-add-question")
  const blockNewQuestions = modalAddTest.querySelector(".new-questions")
  const btnSubmitTest = modalAddTest.querySelector("#submit-test")


  // Выбрать тест
  document.getElementById("tests").addEventListener("click", e => {
    const testId = e.target.dataset.testid
    const testTitle = e.target.dataset.testtitle
    if (testId) {
      modalTest.classList.add("modal-show")
      modalTest.querySelector(".modal-title").innerHTML = testTitle
      getTest(testId, modalTest)
    }
  })

  // Отправить тест
  btnSubmitTest.addEventListener("click", () => {
    const testTitle = modalAddTest.querySelector("#test-title").value
    const questionsNodes = modalAddTest.querySelectorAll(".question")

    let testObj = {
      title: testTitle,
      questions: []
    }

    questionsNodes.forEach(q => {
      const questionText = q.querySelector(".question-text").value

      let questionObj = {
        textQuestion: questionText,
        answers: []
      }

      const answerBlocks = q.querySelectorAll(".answers")
      answerBlocks.forEach(aEl => {
        const answers = aEl.querySelectorAll("div")
        const as = answers.forEach(a => {
          const isCorrectA = a.querySelector("[type=radio]").checked
          const textA = a.querySelector("[type=text]").value
          const answerObj = {
            isCorrect: isCorrectA,
            textAnswer: textA
          }

          questionObj.answers.push(answerObj)
        })
      })

      testObj.questions.push(questionObj)
    })
    // ! готовый testObj для передачи бэку 
    submitTest(testObj)
  })

  const nextQuestionNumbertDefault = 2
  let nextQuestionNumber = nextQuestionNumbertDefault

  // добавить тест
  document.querySelector(".add-test").addEventListener("click", e => {
    nextQuestionNumber = nextQuestionNumbertDefault
    blockNewQuestions.innerHTML = ""
    modalAddTest.classList.add("modal-show")
  })

  // добавить вопрос
  btnAddQuestion.addEventListener("click", e => {
    e.preventDefault()

    const htmlQuestion =
      `
      <div class="question">
        <h5 class="question-title">Вопрос ${nextQuestionNumber}</h5>
        <input type="text" class="question-text form-control">
        <div class="answers">
            <div class="answer">
            <input type="radio" class="form-check-input" name="a${nextQuestionNumber}">
            <input type="text" class="form-control">
            </div>

            <div class="answer">
            <input type="radio" class="form-check-input" name="a${nextQuestionNumber}">
            <input type="text" class="form-control">
            </div>

            <div class="answer">
            <input type="radio" class="form-check-input" name="a${nextQuestionNumber}">
            <input type="text" class="form-control">
            </div>

            <div class="answer">
            <input type="radio" class="form-check-input" name="a${nextQuestionNumber}">
            <input type="text" class="form-control">
            </div>
          </div>
        </div>
      </div>
      `

    const elQuestion = document.createElement("div")
    elQuestion.classList.add("question")
    elQuestion.innerHTML = htmlQuestion
    blockNewQuestions.append(elQuestion)

    nextQuestionNumber++
  })

  // Закрыть модальные окна
  modalTestClose.addEventListener("click", () => {
    modalTest.classList.remove("modal-show")
  })
  modalAddTestClose.addEventListener("click", () => {
    modalAddTest.classList.remove("modal-show")
  })
})

