class UsbDeviceChecker
  attr_reader :usbmatch, :usb
  
  def initialize
    @usbmatch = []
    @usb = Dir.entries("/dev/")
  end

  def check
    @usbmatch.clear       
    @usb.each do |x|      
      unless /tty\Susbserial/.match(x).nil?    
        @usbmatch.push(x)
      end
    end 
       
    userchoice = 0                                      
    n = 1    
    if @usbmatch.length > 1           
        @usbmatch.each do |x| 
          puts "\(" + n.to_s + "\) " + x
          n = n + 1
        end
      userchoice = gets.to_i - 1
    end     
    
    @usbmatch.at(userchoice)           
  end               
end