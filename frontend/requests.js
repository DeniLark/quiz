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

// function testFunc() {

//   const obj = {
//     title: 'ыфввыф',
//     questions: [
//       { text: "2 + 2", answers }
//     ]

//   }

// }