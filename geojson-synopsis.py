#!/usr/bin/env python3

import sys, json

args = sys.argv

def usage():
    print("Usage: " + args[0] + " mygeojsonfile")
    exit()

def get_prop_type(properties):
    my_prop_types = {}
    for x, current in properties.items():
        try:
            if "e-" in current.lower() or "e+" in current.lower():
                if float(current) > 0:
                    data_type = "scientific notation number in string (positive)"
                elif float(current) == 0:
                    data_type = "scientific notation number in string (zero)"
                else:
                    data_type = "scientific notation number in string (negative)"
            elif "." in current:
                if float(current) > 0:
                    data_type = "floating point in string (positive)"
                elif float(current) == 0:
                    data_type = "floating point in string (zero)"
                else:
                    data_type = "floating point in string (negative)"
            else:
                if int(current) > 0:
                    data_type = "integer in string (positive)"
                elif int(current) == 0:
                    data_type = "integer in string (zero)"
                else:
                    data_type = "integer in string (negative)"
        except:
            if current == None:
                data_type = "null"
            elif str(current).lower() == "null":
                data_type = "null in string"
            elif current == "undefined":
                data_type = "undefined in string"
            elif current == "NaN":
                data_type = "NaN in string"
            elif current == "nil":
                data_type = "nil in string"
            elif type(current) is int:
                if current > 0:
                    data_type = "integer (positive)"
                elif current == 0:
                    data_type = "integer (zero)"
                else:
                    data_type = "integer (negative)"
            elif type(current) is float:
                if "e" in str(current):
                    if current > 0:
                        data_type = "scientific notation number (positive)"
                    elif current == 0:
                        data_type = "scientific notation number (zero)"
                    else:
                        data_type = "scientific notation number (negative)"
                else:
                    if current > 0:
                        data_type = "floating point (positive)"
                    elif current == 0:
                        data_type = "floating point (zero)"
                    else:
                        data_type = "floating point (negative)"
            elif type(current) is list:
                data_type = "array"
            elif type(current) is dict:
                data_type = "object"
            elif current == "":
                data_type = "empty string"
            elif current.strip() == "":
                data_type = "space filled string"
            else:
                data_type = "string"
        my_prop_types[x] = data_type
    return my_prop_types

def feature_synopsis(feature):
    print("================================")
    print("Type: " + feature[0])
    print("Properties:")
    for key, value in feature[1].items():
        print(key + " - " + value)

if len(args) < 2:
    print("Incorrect usage.")
    usage()

arrangements = []
semi_arrangements = []
          
try:
    with open(args[1]) as file:
        json = json.load(file)
        if json["type"] == "FeatureCollection":
            print("FeatureCollection")
            for i in json["features"]:
                semi_total = [i["geometry"]["type"], list(i["properties"])]
                total = [i["geometry"]["type"], get_prop_type(i["properties"])]
                if not total in arrangements:
                    if semi_total in semi_arrangements:
                        for arrangement in arrangements:
                            if arrangement[0] == semi_total[0] and list(total[1]) == semi_total[1]:
                                for key in arrangement[1]:
                                    if not total[1][key] in arrangement[1][key]:
                                        arrangement[1][key] += " / " + total[1][key]
                    else:
                        arrangements.append(total)
                        semi_arrangements.append(semi_total)
                        
            for y in arrangements:
                feature_synopsis(y)
        else:
            print("Feature")
            feature_synopsis([json["geometry"]["type"], get_prop_type(json["properties"])])
        print("================================")
except:
    print("Invalid file")
    usage()
