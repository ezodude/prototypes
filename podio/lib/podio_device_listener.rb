require "rubygems"
require "serialport"
require "quicktime_podcast_radio"

class PodioDeviceListener
  PORT = "/dev/tty.usbserial-A70060tq"
  BAUD_RATE = 9600 # bits per sec
  DATA_BITS = 8
  STOP_BITS = 1 # use a stop bit
  PARITY = SerialPort::NONE

  def self.listen
    serial_port = SerialPort.new(PORT, BAUD_RATE, DATA_BITS, STOP_BITS, PARITY)
    quicktime_radio = QuicktimePodcastRadio.new
    quicktime_radio_thread = nil
    
    begin
      while true do
        if raw_value = serial_port.gets
          raw_value = raw_value.strip
          puts "Read raw value: [#{raw_value}]"
          
          case raw_value
            when "L" then 
              quicktime_radio_thread = Thread.new { quicktime_radio.play } unless quicktime_radio.playing?
              serial_port.write("P") 
            when /^V\.\d{1,2}$/ then
              quicktime_radio.change_volume_to(raw_value.gsub(/V\./, '').to_i)
            when "S" then
              quicktime_radio.stop
              quicktime_radio_thread.terminate
          end
        end
      end
    ensure
      serial_port.close
    end
  end
end

PodioDeviceListener.listen