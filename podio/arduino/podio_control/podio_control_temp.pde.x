int outLedPin = 5;
int inPushButtonPin = 7;
int incomingByte;

int currentPushButtonValue;

int podioState = LOW;
int podioDownloadingState = LOW;

long lastButtonPressTime = 0;
long debounce = 300;   // the debounce time, increase if the output flickers

void setup()
{
  pinMode(outLedPin, OUTPUT);
  pinMode(inPushButtonPin, INPUT);
  Serial.begin(9600);
  
  digitalWrite(outLedPin, podioState);
}

void loop()                     
{
 currentPushButtonValue = digitalRead(inPushButtonPin);
  
  boolean pushButtonWasPressed = currentPushButtonValue == LOW && millis() - lastButtonPressTime > debounce;
  if (pushButtonWasPressed) 
  {    
    if (podioState == LOW)
    {  
      podioState = HIGH;
      podioDownloadingState = HIGH;
    }
    else
    {
      podioState = LOW;
      podioDownloadingState = LOW;
    }
    
    lastButtonPressTime = millis();    
  }
  
  detectAnyCompletedDownloads();
  
  boolean isDownloading = (podioState == HIGH && podioDownloadingState == HIGH);
  indicateDownloadingState(isDownloading);
  if (isDownloading)
  {
    Serial.println("D");
    delay(10);    
  }

  boolean isDownloadingComplete = (podioState == HIGH && podioDownloadingState == LOW);
  indicateDownloadingCompleteState(isDownloadingComplete);

  boolean isOff = (podioState == LOW);
  indicateOffState(isOff);
}

void detectAnyCompletedDownloads()
{
  if (podioDownloadingState == HIGH)
  {
    if (Serial.available() > 0) 
    {
      incomingByte = Serial.read();
      if (incomingByte == 'C') podioDownloadingState = LOW;
    }
  }
}

void indicateDownloadingState(boolean isDownloading)
{
  if (isDownloading)
  {
    blink();
  }
}

void indicateDownloadingCompleteState(boolean isDownloadingComplete)
{
  if(isDownloadingComplete) digitalWrite(outLedPin, HIGH);
}

void indicateOffState(boolean isOff)
{
  if(isOff) digitalWrite(outLedPin, LOW);
}

void blink()
{
  digitalWrite(outLedPin, HIGH);
  delay(100);
  digitalWrite(outLedPin, LOW);
  delay(100);
}
