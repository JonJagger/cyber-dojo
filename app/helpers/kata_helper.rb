
module KataHelper

  def commatize(n)
    digits,count = "",0
    begin
      digits << "," if count % 3 == 0
      digits << "0123456789"[n % 10]
      count += 1
      n /= 10
    end until n == 0
    digits[1..digits.length].reverse
  end

end


