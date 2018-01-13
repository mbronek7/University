function Quiz(questions) {
    this.score = 0;
    this.questions = questions;
    this.currentQuestionIndex = 0;
}

Quiz.prototype.guess = function(answer) {
    if(this.getCurrentQuestion().isCorrectAnswer(answer)) {
        this.score++;
    }
    this.currentQuestionIndex++;
};

Quiz.prototype.getCurrentQuestion = function() {
    return this.questions[this.currentQuestionIndex];
};

Quiz.prototype.hasEnded = function() {
    return this.currentQuestionIndex >= this.questions.length;
};
function Question(text, choices, answer) {
    this.text = text;
    this.choices = choices;
    this.answer = answer;
}

Question.prototype.isCorrectAnswer = function (choice) {
    return this.answer === choice;
};
var QuizUI = {
    displayNext: function () {
        if (quiz.hasEnded()) {
            this.displayScore();
        } else {
            this.displayQuestion();
            this.displayChoices();
            this.displayProgress();
        }
    },
    displayQuestion: function() {
        this.populateIdWithHTML("question", quiz.getCurrentQuestion().text);
    },
    displayChoices: function() {
        var choices = quiz.getCurrentQuestion().choices;
        if(choices.length == 4){
           for(var i = 0; i < choices.length; i++) {
                this.populateIdWithHTML("choice" + i, choices[i]);
                this.guessHandler("guess" + i, choices[i]);
                this.displayButtons("guess" + i,"show");
            }
        }
        else
        {
            for(var i = 0; i < choices.length; i++) {
                this.populateIdWithHTML("choice" + i, choices[i]);
                this.guessHandler("guess" + i, choices[i]);
                this.displayButtons("guess" + i,"show");
        }
            for(var i=choices.length;i<4;i++){
                this.populateIdWithHTML("choice" + i, "");
                this.guessHandler("guess" + i, "");
                this.displayButtons("guess" + i,"hidden");
            }
        }
    },
    displayScore: function() {
        var gameOverHTML = "<center><h1>Koniec</h1></center>";
        gameOverHTML += "<center><h2> Twój wynik: " + quiz.score + "/" + quiz.questions.length + "</h2></center>"+"  <center>  <footer> Autor testu: Michał Bronikowski</footer> </center>";
        this.populateIdWithHTML("quiz", gameOverHTML);
    },

    populateIdWithHTML: function(id, text) {
        var element = document.getElementById(id);
        element.innerHTML = text;
    },
    displayButtons: function(id,action) {
        var element = document.getElementById(id);
        if (action == "show") {
            element.style.visibility = "visible";
        } else {
            element.style.visibility = "hidden";
        }
    },
    guessHandler: function(id, guess) {
        var button = document.getElementById(id);
        button.onclick = function() {
            quiz.guess(guess);
            QuizUI.displayNext();
        }
    },

    displayProgress: function() {
        var currentQuestionNumber = quiz.currentQuestionIndex + 1;
        this.populateIdWithHTML("progress", "Pytanie " + currentQuestionNumber + " z " + quiz.questions.length);
    },
};
//Create Questions
var questions = [
    new Question("Co to jest system operacyjny",["Program, który działa jako pośrednik między użytkownikiem komputera a sprzętem komputerowym","Program, który działa jako pośrednik między procesorem a twardym dyskiem","Tak nazywano kiedyś pierwsze programy napisane w COBOLU"],"Program, który działa jako pośrednik między użytkownikiem komputera a sprzętem komputerowym."),
    new Question("Co nie pasuje do reszty?", ["UNIX","LINUX", "PREPROCESOR", "MS-DOS"], "PREPROCESOR"),
    new Question("Jaki cel nie stoi przed twórcami systemów operacyjnych",["Przenośność","Uniemożliwienie ewolucji systemu","Wydajność","Wygoda użytkownika"],"Uniemożliwienie ewolucji systemu"),
    new Question("Systemy czasu rzeczywistego",["Reagują na określone zdarzenia w określonym czasie","Gwarantują nieprzekraczalny czas reakcji"],"Reagują na określone zdarzenia w określonym czasie"),
    new Question("Do cech systemów rozproszonych należy",["Ograniczona pamięć","Wolny procesor","Umożliwienie współdzielenia plików"],"Umożliwienie współdzielenia plików"),
    new Question("Systemy czasu rzeczywistego mogą być",["Łagodne","Wścibskie","Natrętne"],"Łagodne"),
    new Question("System operacyjny nie odpowiada za",["Przydzielanie i zwalnianie pamięci stosownie do potrzeb i aktualnych możliwości","Decydowanie, który proces załadować, gdy w pamięci zwolni się miejsce","Wysyłanie żądań przydziału zasobów komputerowych"],"Wysyłanie żądań przydziału zasobów komputerowych"),
    new Question("System wejścia-wyjścia składa sie z",["Systemu buforowania i przechowywania podręcznego","Jądra systemowego"],"Systemu buforowania i przechowywania podręcznego"),
    new Question("Co stanowi najwyższą warstwę w systemie operacyjnym",["Sprzęt","Pamięć operacyjna","Interfejs użytkownika","Urządzenia wejścia-wyjścia"],"Interfejs użytkownika"),
    new Question("System operacyjny jest łatwiejszy do przenoszenia (na inny sprzęt) jeśli",["Jest napisany w języku wysokiego poziomu","Jest napisany w języku niskiego poziomu"],"Jest napisany w języku wysokiego poziomu")
];

//Create Quiz
var quiz = new Quiz(questions);

//Display Quiz
QuizUI.displayNext();
