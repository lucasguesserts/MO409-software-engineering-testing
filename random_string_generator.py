import random
import string

length = 255

output_string = ''.join(
    random.SystemRandom()
    .choice(string.ascii_letters + string.digits)
    for _ in range(length)
)

print(output_string)
