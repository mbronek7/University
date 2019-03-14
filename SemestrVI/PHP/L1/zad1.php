<?php

  $letters = $argv[1];
  $substitutions = $argv[2];
  $sentence = $argv[3];
  $result = $argv[3];
  $letters_size = strlen($letters);
  $sentence_size = strlen($sentence);

  for($i = 0; $i < $letters_size; $i++) {
    $temp = str_replace($letters[$i], $substitutions[$i], $sentence);
    for ($x = 0; $x < $sentence_size; $x++) {
      if($sentence[$x] != $temp[$x]){
        $result[$x] = $temp[$x];
      }
    }
  }
  echo $result;
