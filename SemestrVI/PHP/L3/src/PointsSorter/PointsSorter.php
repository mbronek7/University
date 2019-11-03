<?php

namespace University\PointsSorter;

use University\ISorter;
use University\Application\Application;


class PointsSorter implements ISorter
{
  public function sort(array $applications): array
  {
    usort($applications, [$this, "cmp"]);
    return $applications;
  }

  private function cmp(Application $a, Application $b)
  {
    if ($a->getPoints() == $b->getPoints()) {
      return 0;
    }
    return ($a->getPoints() < $b->getPoints()) ? -1 : 1;
  }
}
