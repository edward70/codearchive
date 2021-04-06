import re
def give():
    with open('advent4.txt', 'r') as f:
        return [re.split('[\n ]', i) for i in f.read().split('\n\n')]

a = give()
print(a)



valid, invalid = [0,0]
for i in a:
    il = []
    dl = []
    fail = False
    for j in i:
        x = j[0:3]
        y = j[4:len(j)]
        
        try:
            if x == 'byr':
                y = int(y)
                if not y >= 1920 and y <= 2002:
                    fail = True

            if x == 'iyr':
                y = int(y)
                if not y >= 2010 and y <= 2020:
                    fail = True

            if x == 'eyr':
                y = int(y)
                if not y >= 2020 and y <= 2030:
                    fail = True

            if x == 'hgt':
                q= y[len(y)-2:len(y)]
                w = y[0:len(y)-2]
                if not q == "cm" or q == "in" and 
                    fail = True
            if x == 'hcl':
                y = int(y)
                if not y >= 2010 and y <= 2020:
                    fail = True

            if x == 'ecl':
                if not y in [amb,blu,brn,gry,grn,hzl,oth]:
                    fail = True

            if x == 'pid':
                y = int(y)
                if not len(y) == 9:
                    fail = True
            
        except:
            fail = True
            
        if not len(j[0:3]) == 3:
            print(i)
        il.append(j[0:3])
        dl.append(j[4:len(j)])
    if fail:
        invalid = invalid + 1
    elif 'byr' in il and 'iyr' in il and 'eyr' in il and 'hgt' in il and 'hcl' in il and 'ecl' in il and 'pid' in il:
        valid = valid + 1
    else:
        invalid = invalid + 1


print(valid, invalid)


