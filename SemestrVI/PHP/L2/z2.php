<?php

class Number {
  private $value;
  private $base;
  public $default_value;
  private $default_base = 10;
  public function __construct($value, $base) {
      $this->value = $value;
      $this->base = $base;
      $this->default_value = (int) base_convert(strval($value), $base, $this->default_base,);
  }
  public function getDefaultValue() {
    return $this->default_value;
  }
  public function add(Number $number) {
      return new Number($this->value + $number->getDefaultValue(), $this->default_base);
  }
}

interface NumberFormatter {
  public function format(Number $number);
}

class RomanFormatter implements NumberFormatter {

    public function format(Number $number) {
        $result = '';
        $value = $number->getDefaultValue();
        foreach ($this->romanNumerals as $romanRepresentation => $romanValue) {
          $times = intdiv($value, $romanValue);
          for($i=0;$i<$times;$i++){
            $result .= $romanRepresentation;
          }
          $value %= $romanValue;
        }
        return $result;
    }

    private $romanNumerals = [
      'M' => 1000,
      'CM' => 900,
      'D' => 500,
      'CD' => 400,
      'C' => 100,
      'XC' => 90,
      'L' => 50,
      'XL' => 40,
      'X' => 10,
      'IX' => 9,
      'V' => 5,
      'IV' => 4,
      'I' => 1
    ];

}

$formatter = new RomanFormatter();
$result = new Number(0, 10);

for ($i = 1; $i < $argc; $i++) {
  $number = explode(":", $argv[$i]);
  $temp = new Number($number[0], $number[1]);
  $result = $result->add($temp);
};

echo($formatter->format($result));
