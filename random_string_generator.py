import random
import string
import sys

length = int(sys.argv[1])

output_string = ''.join(
    random.SystemRandom()
    .choice(string.ascii_letters + string.digits)
    for _ in range(length)
)

print(output_string)
