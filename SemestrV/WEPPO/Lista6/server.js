var http = require('http');
var express = require('express');
var url = require('url')
var https = require('https');
var fs = require('fs');
var multer = require('multer')
var upload = multer({
  dest: 'uploads/'
})
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');
var csrf = require('csurf');
var FileStore = require('session-file-store')(session);
var csrfProtection = csrf({
  cookie: true
})
var parseForm = bodyParser.urlencoded({
  extended: false
})

var app = express();

app.set('view engine', 'ejs');
app.set('views', './views');
app.use(cookieParser());


app.use('/sessions', session({
  secret: 'fjalksfhjdsbjkkajbjksad;flfnajsdkbfgasd;fbsadfnaslf;lafjkfsfbasdl',
  store: new FileStore,
  resave: false,
  saveUninitialized: true,
  cookie: {
    maxAge: 1000 * 10
  }
}));


app.get('/', (req, res) => {
  res.render('main');
});


app.get('/file', (req, res) => {
  res.render('file');
});


app.post('/file', upload.single('file'), function (req, res) {
  res.render('main.ejs')
});




app.get('/radio', (req, res) => {
  var model = {
    t1: "Przekazanie parametru z kodu",
    t2: "include:"
  }
  res.render('radio', model);
})




app.get('/cookie', (req, res) => {
  var model = {}
  res.cookie('cookie1', 'valueOfCookie1', {
    maxAge: 1000
  });
  res.cookie('cookie2', 'valueOfCookie2', {
    maxAge: 120 * 10000
  });
  model.cookie = req.cookies;
  res.render('ciastka', model);
})




app.get('/clear', (req, res) => {
  res.clearCookie('cookie1');
  res.clearCookie('cookie2');
  res.redirect('/');
})




app.get('/sessions', (req, res, next) => {
  var sess = req.session;

  if (sess.name) {
    res.write('Hi ' + sess.name + '\n');
    res.end()
  } else {
    sess.name = req.query.name;
    res.end('hi enter your name in url and refresh!')
  }
})





app.get('/form', csrfProtection, function (req, res) {
  res.render('form', {
    csrfToken: req.csrfToken()
  })
})




app.post('/process', parseForm, csrfProtection, function (req, res) {
  res.send('Your transaction was paid succesfully')
})

var server = http.createServer(app).listen(3000);