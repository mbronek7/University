<?php

namespace University\ApplicationSorter;

use University\ISorter;
use University\Application\Application;


class ApplicationSorter implements ISorter
{
  public function sort(array $applications)
  {
    usort($applications, [$this, "cmp"]);
    return $applications;
  }

  private function cmp(Application $a, Application $b)
  {
    if ($a->getSubmissionDate() == $b->getSubmissionDate()) {
      return 0;
    }
    return ($a->getSubmissionDate() < $b->getSubmissionDate()) ? -1 : 1;
  }
}
