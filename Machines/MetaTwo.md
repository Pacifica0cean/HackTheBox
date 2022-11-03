<h1> MetaTwo </h1>

An <b>EASY</b> machine.

<h4>Summary</h4>

This machine isn't as easy as the print on the tin says. This machine involves WordPress, a web platform that is often quite exploitable. It also utilizes a fairly recently found exploit, using POST to inject some malicious data, as well as another exploit for abusing the Media Library.


More to be added as I poke this machine more, currently in the process of figuring out how to exploit this.


<h2> Documentation </h2>

• <b> CVE-2022-0739 </b> https://nvd.nist.gov/vuln/detail/CVE-2022-0739

• <b> BOOKINGPRESS EXPLOIT </b> https://wpscan.com/vulnerability/388cd42d-b61a-42a4-8604-99b812db2357

• <b> USING SQLMAP FOR POST INJECTION </b> https://hackertarget.com/sqlmap-post-request-injection/ , https://edricteo.com/sqlmap-commands/

• <b> CVE-2021-29447 </b> https://nvd.nist.gov/vuln/detail/CVE-2021-29447

• <b> WORDPRESS EXPLOIT LIST </b> https://wpscan.com/wordpress/562

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

This proof of concept shows a curl request that sends off that injection using the details listed in the CVE above. As it's a POST request, this information that it's curling is going to very much just be sent in a packet to the website, with those fields in the speechmarks likely being the parameters for that injection. Originally, I just tried shooting off the curl request without changing any information, but I found that the '_wpnonce' had to actually be amended and changed to my own. I found that, in the source code of the events pagem like so.

![image](https://user-images.githubusercontent.com/115663211/199824650-bd0eecc2-14fd-41a2-963f-6c2cf7aaef3f.png)

We have our data. I couldn't figure out just what I was doing wrong in the command line for the curl request to not be sent over to burp, so I took a generic empty packet, modified it according to a simple POST request and shot it off to the website, allowing the fields in my POST request to change accordingly, (notably the Content-Length).

![image](https://user-images.githubusercontent.com/115663211/199826935-e90a0e3e-42f6-4984-91c0-bd0fae8c3c53.png)

Its nasty, yet it works. So what exactly does this give us? Well, a payload for a start. That's exactly what this was written as. We just now need to find where we're going to push the payload. Going back to earlier, we found that a DB was listed in Wappalyzer. So, we could probably shoot this payload off using sqlmap or one of it's buddy programs. I save the POST request to a random file, then move to sqlmap.

At this point I did some further digging outside of the environment, looking into the request I was actually writing. I found that it was, indeed, calling out to a DB. I modified the payload a little bit to suit some information I'd found online.

![image](https://user-images.githubusercontent.com/115663211/199828517-8689bea0-3f54-48a4-a610-ba1aeccec87f.png)

Good news. By changing our payload to suite what was requested online, I was able to get some information from sqlmap. It chucked all of its log information into a file for us to conveniently read. Now, it's time to use the --dbs flag, getting all databases.

![image](https://user-images.githubusercontent.com/115663211/199828846-3df6ab64-2030-4f27-af2b-a7a0f1c0e144.png)

We have two. No point ignoring one in favor of the other, so I start with blog first. I had to do some switch research on sqlmap to figure out how to read this database, but let's have a look at it regardless.

![image](https://user-images.githubusercontent.com/115663211/199829725-ee180808-fff9-4db0-a16d-cfcb6940ffa3.png)

We're given twenty seven tables to pick apart, but i'm pretty sure you know which one we're going for here. I take to opening up the wp_users table to see what's inside, having to, again, do some switch research to figure this out (all these switches to remember are confusing!)

![image](https://user-images.githubusercontent.com/115663211/199830101-dac189eb-5d71-4194-a46c-13d2a7639002.png)

We have two users that are dumped out when we run our commands. The url user utilises 'admin' as it's login, with the one below, <blank> using 'manager' as it's login. Regardless, the passwords are hashed. Which... Doesn't do us much good. That's fine, we have john, a hash decrypter which is infamous on my virtual machine for breaking down. So let's see if it has the guts to take this hash.
  
![image](https://user-images.githubusercontent.com/115663211/199831013-3cc7cce7-e76d-4e6a-9610-d3af5bc81996.png)

By absolute luck, my john didn't crash AND I got the hash to password number two! So we have the combo of 'manager' and 'partylickarockstar' ... Which is great, so where do we use these credentials? Well, we can try SSH first.

![image](https://user-images.githubusercontent.com/115663211/199831587-e76d80ef-0455-4d14-a691-447fb118a253.png)

No dice on that, what about FTP?

![image](https://user-images.githubusercontent.com/115663211/199831737-96948f7c-cffb-484a-9ba5-8e4ca3afd1e2.png)

Okay, so the last option I could think of is that it's a web based login. I checked around online, finding a series of wordpress directories that could be used for login such as /login/, /admin/ and /wp-login.php ... The first two didn't work, but /wp-login.php did. Which, brought me to the splash.

![image](https://user-images.githubusercontent.com/115663211/199832071-32c8c66e-c5f0-4d2d-94f3-6def74dd0213.png)
![image](https://user-images.githubusercontent.com/115663211/199832114-514ea20d-0d0b-4600-9e78-78dd1e720c7a.png)

It let's us in! Wappalyzer then showed that WordPress was running 5.6.2. I can check online for any particular exploits that are known for that version. I check CVE's first just like normal.

![image](https://user-images.githubusercontent.com/115663211/199832760-c37c22dc-48a8-4a10-ba81-9aa9c1189dda.png)
![image](https://user-images.githubusercontent.com/115663211/199832898-af85aa43-5aab-44c7-984a-cf5c196f4f8f.png)

-- TBC, RESEARCH ONGOING --
