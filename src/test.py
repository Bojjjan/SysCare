text = """                                                                                                      
Name                   Id                 Version       Available     Source
----------------------------------------------------------------------------
7-Zip 24.08 (x64)      7zip.7zip          24.08         24.09         winget
SceneBuilder           Gluon.SceneBuilder 21.0.0        23.0.1        winget
Brave                  Brave.Brave        131.1.73.91   131.1.73.97   winget
Microsoft Edge         Microsoft.Edge     131.0.2903.63 131.0.2903.86 winget
Python 3.12.7 (64-bit) Python.Python.3.12 3.12.7        3.12.8        winget
6 upgrades available.

The following packages have an upgrade available, but require explicit targeting for upgrade:
Name    Id              Version  Available Source
-------------------------------------------------
Discord Discord.Discord 1.0.9172 1.0.9173  winget
"""

lines = text.splitlines()


header = lines[1]
id_start = header.index("Id")
version_start = header.index("Version")


ids = []
for line in lines[3:]: 
    if len(line.strip()) == 0:
        break
    if len(line) > id_start:  
        
        id_field = line[id_start:version_start].strip()
        if id_field:
            ids.append(id_field)


print(ids)
