""" THis example from Grok, relies on :
Tesseract version: 5.3.4 (with Leptonica support and various optimizations like AVX512).
Install: $ sudo apt update && sudo apt install tesseract-ocr

Python wrapper: pytesseract 
$ pip3 install pytesseract pillow  # pillow is needed to handle images easily.

It's one of the most popular and mature open-source OCR engines (originally from HP, now maintained by Google).
See: https://pytesseract.readthedocs.io/en/latest/

"""


import pytesseract
from PIL import Image

# Load an image (e.g., from a file path in the sandbox or via other means)
img = Image.open("PDS-export.png")  # or use requests/PIL to load from URL/bytes

text = pytesseract.image_to_string(img)
print(text)

# Advanced options
# text = pytesseract.image_to_string(img, lang='eng')  # specify language
# data = pytesseract.image_to_data(img, output_type=pytesseract.Output.DICT)  # get bounding boxes, confidence, etc.