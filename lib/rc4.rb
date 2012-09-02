require 'base64'
class RC4
  def self.hide_data(data, bytes, key, secret, base64)
    key = RC4.new(key + secret).encrypt("\0" * 32) + data
    crypt = RC4.new(key).encrypt("\0" * bytes)
    if base64
      Base64.encode64(crypt)
    else
      crypt
    end
  end

  def initialize(str)
    begin
      raise SyntaxError, "RC4: Key supplied is blank"  if str.eql?('')

      @q1, @q2 = 0, 0
      @key = []
      str.each_byte {|elem| @key << elem} while @key.size < 256
      @key.slice!(256..@key.size-1) if @key.size >= 256
      @s = (0..255).to_a
      j = 0 
      0.upto(255) do |i| 
        j = (j + @s[i] + @key[i] )%256
        @s[i], @s[j] = @s[j], @s[i]
      end    
    end
  end
  
  def encrypt!(text)
    process text
  end  
  
  def encrypt(text)
    process text.dup
  end 

  alias_method :decrypt, :encrypt
  
  private

  def process(text)
    text.unpack("C*").map { |c| c ^ round }.pack("C*")
  end
  
  def round
    @q1 = (@q1 + 1)%256
    @q2 = (@q2 + @s[@q1])%256
    @s[@q1], @s[@q2] = @s[@q2], @s[@q1]
    @s[(@s[@q1]+@s[@q2])%256]  
  end
end