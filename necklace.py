import argparse

parser = argparse.ArgumentParser(description="Challenge #383 Necklace matching")
parser.add_argument("normal")
parser.add_argument("shifted")

args = parser.parse_args()

normal = args.normal
shifted = args.shifted

if len(normal) == len(shifted):
    double = shifted + shifted

    if normal in double:
        print("Necklace {} matches {}".format(shifted, normal))
        exit()

print("Necklaces do not match")