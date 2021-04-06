# read numbers
numbers = []
with open("nums.txt", "r") as f:
    lines = f.readlines()
    numbers = [int(i) for i in lines]

print(numbers)

# part 1 soln
for x,el in enumerate(numbers):
    for i in range(x+1, len(numbers)):
        if el + numbers[i] == 2020:
            print("YAY: {} {}".format(el, numbers[i]))

# part 2 soln
for x,el in enumerate(numbers):
    for i in range(x+1, len(numbers)):
        for j in range(i+1, len(numbers)):
            if el + numbers[i] + numbers[j] == 2020:
                print("YAY: {} {} {}".format(el, numbers[i], numbers[j]))
            
