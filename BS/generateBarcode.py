import barcode
from barcode.writer import ImageWriter
import argparse
import os


def generate_code128_barcode(data):
	code128 = barcode.get('code128', data, writer=ImageWriter())

	filepath = "./barcodes"
	
	if not os.path.exists(filepath):
		os.makedirs(filepath)

	filepath = os.path.join(filepath, data)

	filepath = code128.save(filepath)
	print(f"Barcode saved at {filepath}")


parser = argparse.ArgumentParser()

parser.add_argument('--code', required=True)

arg = parser.parse_args()

generate_code128_barcode(arg.code)
