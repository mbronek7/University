
MAX_LENGTH = 30

def find_words(text, dictionary):
  if text == "":
    return True, [], 0

  if text in dictionary:
    return True, [text], len(text)**2

  if len(text) == 1:
    return False, [], 0

  mid = len(text) // 2
  is_complete, list_of_words, value = False, [], 1

  for i in range( max(0, mid-MAX_LENGTH), mid+1 ):
    for j in range(mid, min(mid+MAX_LENGTH, len(text) )+1 ):
      if j-i >= MAX_LENGTH:
        break
      if text[i:j] in dictionary:
        is_left_complete, left_list, left_max = find_words( text[0:i], dictionary )
        if is_left_complete == False:
          continue
        is_right_complete, right_list, right_max = find_words( text[j:], dictionary )
        if is_right_complete == False:
          continue
        if first_compatibility(is_complete):
          is_complete = True
          list_of_words = left_list + [ text[i:j] ] + right_list
          value = left_max + len(text[i:j])**2 + right_max
        elif value < left_max + len(text[i:j])**2 + right_max:
          list_of_words = left_list + [ text[i:j] ] + right_list
          value = left_max + len(text[i:j])**2 + right_max
  return is_complete, list_of_words, value

def reconstruct_text(text, dictionary):
    _, words, _ = find_words(text, dictionary)
    if words:
      return words

def first_compatibility(complete):
    return complete == False

def dic():
    dictionary = set(open('polish_words.txt').read().split())
    return dictionary

def text():
    return open('zad2_input.txt').readlines()

dictionary = dic()
text = text()

file = open('zad2_output.txt', 'w')

for row in text:
    words = reconstruct_text(row.strip(), dictionary)
    file.write((" ").join(words))
    file.write("\n")

file.close()