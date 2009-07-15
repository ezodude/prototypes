#include "WProgram.h"
void setup();
void loop();
void startInitialDownload();
void stopRadioFromPlaying();
void stopAnyOngoingDownloads();
void detectAnyCompletedDownloads();
void indicateDownloadingState(boolean isDownloading);
void indicateDownloadingCompleteState(boolean isDownloadingComplete);
void indicateOffState(boolean isOff);
void blink();
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
      startInitialDownload();
    }
    else
    {
      stopRadioFromPlaying();
      podioState = LOW;
      stopAnyOngoingDownloads();
    }
    
    lastButtonPressTime = millis();    
  }
  
  detectAnyCompletedDownloads();
  
  boolean isDownloading = (podioState == HIGH && podioDownloadingState == HIGH);
  indicateDownloadingState(isDownloading);

  boolean isDownloadingComplete = (podioState == HIGH && podioDownloadingState == LOW);
  indicateDownloadingCompleteState(isDownloadingComplete);

  boolean isOff = (podioState == LOW);
  indicateOffState(isOff);
}

void startInitialDownload()
{
  podioDownloadingState = HIGH;
  Serial.println("D");
}

void stopRadioFromPlaying()
{
  Serial.println("S");
  delay(200);
}

void stopAnyOngoingDownloads()
{
  podioDownloadingState = LOW;
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
  if (isDownloading) blink();
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

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

