<h1> MetaTwo </h1>

An <b>EASY</b> machine.

<h4>Summary</h4>

This machine has only recently been released, thus there is little to no documentation on it. This document will be updated as I attack this machine in detail.


<h2> Documentation </h2>


<h2> Walkthrough </h2>

I begin with a fairly aggressive Nmap. This took some time to get done, but when done, three ports opened themselves up to me.
![image](https://user-images.githubusercontent.com/115663211/199806271-3f6008c5-5725-42b0-a86e-e401cc60c056.png)

All are incredibly interesting, with SSH being the first thing I try to attack with the standard anonymous login.
![image](https://user-images.githubusercontent.com/115663211/199806452-fa01f296-4595-492a-9def-3fac2fc9eea7.png)

No luck here. That's fine, we still have two other ports that we can investigate further. I back out of the SSH port and head over to ftp. These are usually the most fragile ports on easy machines.
