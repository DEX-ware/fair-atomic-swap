#!/usr/bin/env python

print("Run with python3")
hex_str = str(input("Input hex_str without \"0x\":\n"))
# array
if len(hex_str)%2 != 0:
    print("Odd!")
else:
    print("[", end = '')
    for i in range (int(len(hex_str)/2) - 1):
        print(("\"0x"+hex_str[i:i+2]), end = '\", ')
    print(("\"0x"+hex_str[-2:]), end = '\"')
    print("]")
