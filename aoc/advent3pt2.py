def givemap():
    with open('advent3.txt', 'r') as f:
        return [i.replace('\n', '') for i in f.readlines()]

treemap = givemap()
rows = len(treemap)

slopes = [[1,1], [3,1], [5,1], [7,1], [1,2]]

treemult = 1

for slope in slopes:
    hindex, vindex = [0,0]
    trees = 0
    for row in range(rows):
        if row == rows - (2 * slope[1] - 1): # check if last row
            break

        vindex = vindex + slope[1]
        hindex = hindex + slope[0]

        try:
            item = treemap[vindex][hindex % len(treemap[vindex])]
        except:
            break

        if item == "#":
            trees = trees + 1

    treemult = treemult * trees
    print(treemult)

print(treemult)
