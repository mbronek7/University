<?php

namespace University;

interface ISplitter
{
  public function split(array $applications): array;
}
