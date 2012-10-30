Create functions to encode a number to and decode
a number from Gray code. Display the normal binary
representations, Gray code representations, and
decoded Gray code values for all 5-bit binary
numbers (0-31 inclusive, leading 0's not necessary).

There are many possible Gray codes. The following
encodes what is called "binary reflected Gray code."

Encoding (MSB is bit 0, b is binary, g is Gray code):
  if b[i-1] = 1
     g[i] = not b[i]
  else
     g[i] = b[i]


Decoding (MSB is bit 0, b is binary, g is Gray code):
  b[0] = g[0]

  for other bits:
  b[i] = g[i] xor b[i-1]


[Source http://rosettacode.org]