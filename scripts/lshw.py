#!/usr/bin/env python

# This script parse linux command - "lshw" output to collect hardware information. 
# and raise alert - Email/SMS in case of hardware mismatch
# Make sure that the package lshw is installed on the system
# if not, install using ```sudo apt-get install lshw```

# JSON objects comparison - https://www.geeksforgeeks.org/how-to-compare-json-objects-regardless-of-order-in-python/

from subprocess import Popen, PIPE
from os.path import exists as file_exists
import logging
import sys

INVENTORY_FILE = '/tmp/hw_inventory.json'
LSHW_FILE = '/usr/bin/lshw'

# setup logging
logging.basicConfig(stream=sys.stdout,level = logging.DEBUG)
logger = logging.getLogger(__name__)

def json_sorting(item):
    if isinstance(item, dict):
        return sorted((key, sorting(values)) for key, values in item.items())
    if isinstance(item, list):
        return sorted(sorting(x) for x in item)
    else:
        return item

# check if package - "lshw" exists or not.
# if not, install it using $sudo apt-get install lshw
if not file_exits(LSHW_FILE):
    logger.error("The utility for getting hardware information - 'lshw' is not installed on the system. Kindly install it using "apt-get" like package manager and then try again.")
    sys.exit(1)

hw_inventory =Popen([LSHW_FILE, '-json', '-numeric'], stdout=PIPE).communicate()[0]
# format the json result
formated_hw_inventory = json.dumps(hw_inventory, sort_keys=True, indent=4)

# check if previous inventory file exist
if file_exists(INVENTORY_FILE):
    with open(INVENTORY_FILE) as file:
        existing_inventory_json=json.load(file)

    # if yes, read it into JSON object. Compare this with the current inventory object. 
    # check if there are any differences.
    
    formated_existing_inventory_json = json.dumps(existing_inventory_json, sort_keys=True, indent=4)
    #print(json_sorting(formated_existing_inventory_json) == json_sorting(formatted_hw_inventory))
    if json_sorting(formated_existing_inventory_json) == json_sorting(formatted_hw_inventory):
        print("No changes in hardware are detected.")
    else:
        print("Some changes in hardware are detected. Please check the motherboard and SD cards carefully to avoid any subsequent mishaps!")
else:
    # if not, write JSON to current inventory file.
    with open(INVENTORY_FILE, 'w') as file:
        json.dump(formated_hw_inventory, file)
    print("Hardware inventory file %s is generated and will be used for detecting any subsequent changes" %INVENTORY_FILE)
    sys.exit(1)

#if __name__ == "__main__":
#    try:
#        print("hello")
#    Except Exception as exc:
#        logger.error("Error while getting hardware information - %s" %exc.message,exc_info=True)

