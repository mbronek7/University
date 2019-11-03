<?php

namespace University;

interface ISorter {
  public function sort(array $applications): array;
}