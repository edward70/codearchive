import argparse

parser = argparse.ArgumentParser(description='Chip8 ROM to big endian int conversion script')
parser.add_argument('filename', help='File to convert')
args = parser.parse_args()

intified = []

with open(args.filename, 'rb') as f:
    byte = f.read(1)
    while byte: # check EOF
        intified.append(str(int.from_bytes(byte, 'big'))) # convert to int big endian
        byte = f.read(1)

int_string = ", ".join(intified)

print("myrom = {%s}" % (int_string))
