def givemap():
    with open('advent3.txt', 'r') as f:
        return [i.replace('\n', '') for i in f.readlines()]

treemap = givemap()
rows = len(treemap)
vindex, hindex = [0, 0]
trees = 0
for row in range(rows):
    if row == rows - 1: # check if last row
        break

    vindex = vindex + 1
    hindex = hindex + 3

    item = treemap[vindex][hindex % len(treemap[vindex])]

    if item == "#":
        trees = trees + 1

print(trees)
