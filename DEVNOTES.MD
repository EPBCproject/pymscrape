# Introduction
This file provides notes that may assist future pymscrape development.

# Menu and GUI
The code for the menu and GUI features can be found in `menu.py` and `gui.py`. The menu and other GUI classes are built around the python package `tkinter`. The menu was built very quickly to provide a proof of concept. It is missing ease of use features. The menu flow logic is also imperfect, e.g. if a popup window is closed before completing the step associated with that window, errors may result (simply restart pymscrape if this happens.)

# Extract SVG data
The relevant code is contained in `scrape_svg.py`. The main function is called `scrape_csv`. This function uses PyMuPDF (the `fitz` module) to extract raw SVG data from the PDF. Sometimes a single object is stored in multiple SVG "path" objects, and `scrape_svg` will attempt to piece them together. Inversely, sometimes multiple objects are described by a single "path", and in these cases `scrape_svg` attempts to break these paths up.  

It then attempts to match it with legend objects.
