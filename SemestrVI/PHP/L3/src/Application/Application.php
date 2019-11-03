<?php

namespace University\Application;
use University\Student\Student;


class Application
{
  /**
* @var Student
*/
  private $student;

  /**
* @var DateTimeImmutable
*/
  private $submissionDate;

  /**
* @var int
*/
  private $points;

  public function __construct(\DateTimeImmutable $submissionDate, Student $student, int $points)
  {
    $this->submissionDate = $submissionDate;
    $this->student = $student;
    $this->points = $points;
  }

  public function getStudent(): Student
  {
    return $this->student;
  }

  public function getSubmissionDate(): DateTimeImmutable
  {
    return $this->submissionDate;
  }

  public function getPoints(): int
  {
    return $this->points;
  }
}
