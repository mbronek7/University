<?php

namespace University\AmountSplitter;

use University\ISplitter;
use University\Application\Application;


class AmountSplitter implements ISplitter
{
  /**
     * @array amounts
     */
  private $amounts;

  public function __construct(array $amounts)
  {
    $this->amounts = $amounts;
  }

  public function split(array $applications): array
  {
    $result = [];

    for ($i = 0; $i < sizeof($this->amounts); $i++) {
      if ($i == 0) {
        $offset = 0;
      } else {
        $offset = $this->amounts[$i - 1];
      }

      $temp = array_slice($applications, $offset, $this->amounts[$i]);
      array_push($result, $temp);
    }

    return $result;
  }
}
