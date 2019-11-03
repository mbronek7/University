<?php

namespace University\Student;

class Student
{
  /**
     * @var string
     */
  private $firstName;

  /**
     * @var string
     */
  private $lastName;

  public function __construct($firstName, $lastName)
  {
    $this->firstName = $firstName;
    $this->lastName = $lastName;
  }

  public function getFirstName(): string
  {
    return $this->firstName;
  }

  public function getLastName(): string
  {
    return $this->lastName;
  }
}
