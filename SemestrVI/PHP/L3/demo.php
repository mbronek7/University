<?php

require 'vendor/autoload.php';

use University\Application\Application;
use University\Student\Student;
use University\AmountSplitter\AmountSplitter;
use University\PointsSorter\PointsSorter;

$applications = [];

for($i = 0; $i < 300; $i++) {
  $newStudent = new Student($i."NAME", $i."SECON_DNAME");
  $int= mt_rand(1062055681,1262055681);
  $date = date("Y-m-d H:i:s",$int);
  $newDate = new \DateTimeImmutable($date);
  $points = rand(1, 1000);
  $newApplication = new Application($newDate, $newStudent, $points);
  array_push($applications, $newApplication);
}

var_dump(
(new AmountSplitter([100, 10, PHP_INT_MAX]))->split(
  (new PointsSorter())->sort($applications)
)
);