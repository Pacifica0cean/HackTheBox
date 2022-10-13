<h1> Photobomb </h1>

An <b>EASY</b> machine.

<h4>Summary</h4>

This machine tests a lot of fundamentals about web exploitation, privilege escalation and ENV variables within Linux. It's usage is extremely basic and entertaining, documents for research below.

As a fairly novice Pen Tester (At the time of writing) I'd personally consider this a simply box to crack. As long as you play around with everything at the start, you'll eventually land yourself in the right place just by trial and error, like most things.

The aim of this document is to provide all relevant links to further your knowledge on the machine before undertaking it yourself. I heavily advise to be resilient, be resourceful and not use the walkthrough unless EXTREMELY stuck. You will find the machine to be a lot more entertaining and rewarding upon finding these solutions yourself. 


<h2> Documentation </h2>

• <b>DIRECTORY BUSTING</b> https://www.hackingarticles.in/comprehensive-guide-on-dirbuster-tool/

• <b>NULL BYTE INJECTION</b> http://projects.webappsec.org/w/page/13246949/Null%20Byte%20Injection

• <b>POST AND GET</b> https://www.w3schools.com/tags/ref_httpmethods.asp

• <b>PATH ENV EXPLOITATION</b> https://systemweakness.com/linux-privilege-escalation-using-path-variable-manipulation-64325ab05469


<h2> Walkthrough </h2>

Starting from the basics, I went ahead and ran a pretty dirty brute force nmap against the IP, finding me two quick and easy ports.

<< IMG TO BE PUT IN 

Both looked fairly promising, with SSH being the first port I hit. Unfortunately, though, using the anonymous login with SSH didn't get us very far, so I tried out the webpage. The webpage would redirect, but wouldn't load. So I wrote it to the /hosts file, then proceeded to the page.

<< IMG TO BE PUT IN

From here, dirbuster was my next go to. I put in the most commonly used words as the wordlist parameter, executed it against the host and waited. After a certain amount of time, a particular .js script caught my eye. /photobomb.js

<< IMG TO BE PUT IN

Reading through this JS file presented us with some credentials prepended to the original domain. This brought us to /printer ... A webpage littered with images. Considering the machine to be EASY difficulty, I wasn't under the impression they'd have written any credentials to the metadata of an image. Therefore, I booted up both wireshark and burpsuite, looking for any cleartext when the POST response was sent to the website.

<< IMG TO BE PUT IN

Wireshark proved fairly useless to me originally, leading me to examine the POST request in more detail that was sent when requesting the download of an image from the website. I fiddled around with all the parameters of the request, eventually realizing I could bring up some ruby code by injecting a semi colon into the 'filetype=' field.

<< IMG TO BE PUT IN

I then looked through various exploits that could be put through a HTML request, which led me to a stray article about null bytes. Sure enough, by appending %00 to the 'filetype=' type, I was able to spit out some code. This code showed a line just underneath, indicating that any command written after the semi colon would be put through in full. This showed itself to be an extremely susceptible exploit, allowing me to setup a netcat on my machine, listen on a port and then prepare a reverseshell on the victim.

<< IMG TO BE PUT IN

Voila! A reverseshell. With this initial connection established to the host, I was able to capture the user flag and move onto the second stage, privilege escalation. To start this off, I checked what we could run as <i>wizard</i> with root permissions.

<< IMG TO BE PUT IN

/opt/cleanup.sh had two exploits we'd be taking advantage of. For a start, the script allows us to run it without a password, meaning we can sudo the script as a standard user. The second exploit is less of a purposeful one and more of an oversight, having numerous binaries written to the script without a full path, meaning we can write our dirty code to the name of one of the commands, append it to the PATH environment and run the script.

<< IMG TO BE PUT IN

I chose the 'cd' binary for this exploit. I first changed directory to /tmp. A cleaner environment for me to work in. I then went ahead and wrote the binary for bash into a new fake file named 'cd'. 

<< IMG TO BE PUT IN

Great. Our malicious payload is now set up and ready for us to execute. I then ensured the SUID owner was 'root', ensuring that when this command was ran using sudo, it would run with root privileges.

<< IMG TO BE PUT IN

Finally, I would then go ahead and put /tmp into the $PATH environment variable. In brief, PATH is a variable thats called upon in a bash shell amongst other things to look for command binaries. By putting our dirty code in /tmp and then adding it to PATH, it will then look in that folder, find a command named 'cd' and execute our dirty payload.

<< IMG TO BE PUT IN

There was just one problem. Our ENV variable wasn't being retained whilst executing the command. So, I called the ENV directly into the command line.

<< IMG TO BE PUT IN

Although blank, we'd sure enough gotten a root shell! With this, I was able to cd back to our home, read the root.txt flag and had successfully taken over this machine.

<h2> Closing Remarks </h2>

It goes without saying that this machine was incredibly entertaining. It requires a fundamental knowledge of basic privilege escalation, the willingness to dig deeper into how command binaries work and the likes. It delves into multiple different fields, which proves that sanitary checks are incredibly important in a real world environment.

Overall, I thoroughly enjoyed this box and look forward to knocking another one into the pit.

