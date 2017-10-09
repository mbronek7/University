#define N 
int diody[] = {2, 3, 4, 5};

void setup()
{
  for (int i = 0; i < N; i++) {
    pinMode(diody[i], OUTPUT);
  }
}

void loop()
{

  for (int i = 0; i < N; i++) {
    digitalWrite(diody[i], HIGH);
    delay(100);
    digitalWrite(diody[i], LOW);
  }

}
