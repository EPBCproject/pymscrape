# Copyright (c) 2021 Ewan Short
# This code is part of the pymscrape project
import menu
import tkinter as tk

import argparse

parser = argparse.ArgumentParser()
dir_help = 'full path to base directory containing reference.qgs where map data will be to stored.'
parser.add_argument(
    "base_dir", type=str, help=dir_help)

args = parser.parse_args()

root = tk.Tk()
root.geometry('640x480')
app = menu.Menu(root, base_dir=args.base_dir)
root.mainloop()
