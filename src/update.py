import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
input_file = os.path.join(script_dir, 'temp', 'temp.txt')

# Microsoft.Edge
skipArray = ["Microsoft.Edge", "upgrades"]
newText = []

with open(input_file, 'r') as infile:
    data_section_started = 0
    update_avalible = False
    delete = False

    for line in infile:
        line = line.strip()

        if line.lower().startswith("name") or "--" in line.lower():
            data_section_started = data_section_started + 1
            print(line)  # header
            continue

        if data_section_started >= 2:
            
            # Check against skipArray
            if not any(re.search(rf'\b{item}\b', line) for item in skipArray):
                update_avalible = True
                newText.append(line)

            if not update_avalible:
                newText.clear
                delete = True
                break

            else:
                with open(input_file, 'w') as file:
                    for item in newText:
                        file.write(item + "\n")
                        print(item)
                break
                
if delete:
    os.remove(input_file) 
                    
            