<h1> MetaTwo </h1>

An <b>EASY</b> machine.

<h4>Summary</h4>

This machine isn't as easy as the print on the tin says. This machine involves WordPress, a web platform that is often quite exploitable. It also utilizes a fairly recently found exploit, using POST to inject some malicious data.

More to be added as I poke this machine more.


<h2> Documentation </h2>

• <b> CVE-2022-0739 </b> https://nvd.nist.gov/vuln/detail/CVE-2022-0739

• <b> BOOKINGPRESS EXPLOIT </b> https://wpscan.com/vulnerability/388cd42d-b61a-42a4-8604-99b812db2357



<h2> Walkthrough </h2>

I begin with a fairly aggressive Nmap. This took some time to get done, but when done, three ports opened themselves up to me.
![image](https://user-images.githubusercontent.com/115663211/199806271-3f6008c5-5725-42b0-a86e-e401cc60c056.png)

All are incredibly interesting, with SSH being the first thing I try to attack with the standard anonymous login.
![image](https://user-images.githubusercontent.com/115663211/199806452-fa01f296-4595-492a-9def-3fac2fc9eea7.png)

No luck here. That's fine, we still have two other ports that we can investigate further. I back out of the SSH port and head over to ftp. These are usually the most fragile ports on easy machines.

![image](https://user-images.githubusercontent.com/115663211/199807614-665ff024-50ca-47bd-a284-b5b579309ebb.png)

This leaves the web to finally be attacked. So, I chuck the IP address into a web browser and see what we can get.

![image](https://user-images.githubusercontent.com/115663211/199807728-018626e7-db53-441a-a79a-5c07a1c1c2ac.png)

Like most machines on HTB, this machine doesn't instantly load and fails to resolve the web address. Easy fix, we just write the web address to the /etc/hosts file, then try again.

![image](https://user-images.githubusercontent.com/115663211/199807969-bf11b2b6-b016-44f3-be33-6143d9f9aa92.png)

I think the name of the website really gives away the attack vector here. We're looking at a WordPress built website, which is renown for having security flaws. As a matter of fact, WordPress attack vectors are a very engaging research topic. I first fiddle around with the interior links, that being 'News' and '/events'. News, is useless, however...

![image](https://user-images.githubusercontent.com/115663211/199808269-1775f896-4f2b-4001-9509-e7cc15273078.png)

Events looks like gunk, so it's now time to start checking out the website in our tools. I boot up dirbuster, let's find us some directories!

![image](https://user-images.githubusercontent.com/115663211/199809538-1307422e-b654-4af8-9359-742cc804ff4b.png)

Nothing! I decide to check out Wappalyzer instead, a browser extension which thoroughly digs into the background of a website and gives out information. Wappalyzer directs me to some extra info.

![image](https://user-images.githubusercontent.com/115663211/199809740-6eae902b-3572-4c43-b196-a99f2ab876bf.png)

We know we have a DB running in the background of this website, but, we still cannot see the WordPress version, (This may very well be a problem with my Wappalyzer extension and nothing to do with the website.) I store this information away, then begin digging into the source code of the website. I check Events, as I am already on that page.

![image](https://user-images.githubusercontent.com/115663211/199810276-ae26b043-dda1-4ed1-abcb-f36dc392acdb.png)

There's a lot to take in here, but looking through the information titled 'plugins' at the bottom, I see a plugin named 'bookingpress'. This could be an attack vector, so I note this down, read up on bookingpress and investigate it further, perhaps there's a known exploit online for it? I use nist.gov, a website that I frequently use to check CVE entries, and sure enough...

![image](https://user-images.githubusercontent.com/115663211/199811025-8493a74b-ab67-4d3e-b4d3-d13b1e43fc8b.png)

A (very recent) CVE entry on this WordPress exploit! It shows the version, <1.011 (which we have) and how its exploitable. So we now have our confirmed attack vector, a POST request for SQL injection. While that's all well and good, figuring out just where exactly to shoot off that POST request is another thing. So I took to the interwebs, looking online for information.

![image](https://user-images.githubusercontent.com/115663211/199812493-7111a99d-837c-422d-a5c4-0ead50b2f6b5.png)

This proof of concept shows the /wp-admin directory, which will very much likely need us to be authenticated. This, of course, poses a problem, meaning we must attack the web-end first before we can get any sort of luck with the SQL injection. There is also some information in the Proof of concept about 'nonce' (har, har.) .. as well as _wpnonce.

I check around online and don't find all too much of interest regarding it, but looking into the source code of the website brings me to this.

-- TBC --



