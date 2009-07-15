class Podio < ArduinoSketch
  input_pin 8, :as => :push_button
  output_pin 13, :as => :led
  
  @podio_is_on = false
  @push_button_value = 0
  
  def setup
    digitalWrite(led, LOW)
  end
  
  def loop
    @push_button_value = digitalRead(push_button)
    @podio_is_on =  !@podio_is_on if @push_button_value > 0
    use_led_to_indicate_whether(@podio_is_on)
  end
  
  def use_led_to_indicate_whether(podio_is_on)
    podio_is_on ? digitalWrite(led, HIGH) : digitalWrite(led, LOW)
  end
end
