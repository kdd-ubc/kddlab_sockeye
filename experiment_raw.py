from __future__ import annotations
from functools import reduce
import csv
import sys, os
import argparse
import string
from hashlib import sha256
from random import choice

"""This exists just to showcase the dummy data in principle. 
Suggesting you use cli-driven scripts to be able to pass parameters to job scripts easier."""
#-----------------------------------------------------
# Generate hashes of four-letter words. Dummy data.
def experiment(iteraiton_number:int):
    generated_data = []
    for _ in range(iteraiton_number):
        x = reduce(lambda x,y: str(x)+choice(string.ascii_letters),[0]*4)
        generated_data.append(sha256(str(x).encode('utf-8')).hexdigest())
    return generated_data

YIELD  = experiment(100)

# Writing results to file
with open('results.csv', 'w',newline='') as filein:
    writer = csv.writer(filein)
    for row in YIELD:
        writer.writerow([row])
print("Wrote to ./results.csv")

#-----------------------------------------------------