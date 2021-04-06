with open("advent2.txt", "r") as f:
    lines = f.readlines()

    # part 1
    counter = 0
    for i in lines:
        components = i.split(" ")
        bounds = [int(x) for x in components[0].split("-")]
        num = components[2].count(components[1][0:1])
        if num >= bounds[0] and num <= bounds[1]:
            counter = counter + 1
    print(counter)

    # part 2
    counter = 0
    for i in lines:
        components = i.split(" ")
        bounds = [int(x) for x in components[0].split("-")]
        letter = components[1][0:1]
        password = components[2]
        num = password[bounds[0]-1:bounds[1]].count(letter)
        if password[bounds[0]-1] == letter or password[bounds[1]-1] == letter:
            if not password[bounds[0]-1] == password[bounds[1]-1]:
                counter = counter + 1
    print(counter)
