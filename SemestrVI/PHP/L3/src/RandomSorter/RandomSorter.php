<?php

namespace University\AmountsSplitter;

use University\ISorter;
use University\Application\Application;


class RandomSorter implements ISorter
{
  public function sort(array $applications)
  {
    shuffle($applications);
    return $applications;
  }
}
