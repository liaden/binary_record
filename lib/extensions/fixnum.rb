puts 'wee'
class Fixnum
  def to_hex
    "0x#{to_s(16)}" 
  end
end

puts 1.methods.sort.grep /to_/
