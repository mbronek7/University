var express = require('express');
var router = express.Router();
var url = require('url');

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.render('declaration');
});

router.post('/', function (req, res, next) {
  var name = req.body.name;
  var lecture = req.body.lecture;
  var date = req.body.date;
  var points = [];
  for (var i = 1; i <= 10; i++) {
    let s = `task${i}`
    points.push(req.body[s]);
  }

  res.redirect(
    url.format({
      pathname: "print",
      query: {
        name: name,
        lecture: lecture,
        points: points,
        date: date,
      }
    }));
});

router.get('/print', function (req, res) {
  var model = req.query;
  res.render('print', model);
})

module.exports = router;