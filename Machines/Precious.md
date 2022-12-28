<h1> Precious </h1>

An <b>EASY</b> machine.

<h4>Summary</h4>

Merry Christmas!

This machine involved analyzing the metadata of a file that's downloaded to the machine. You then exploit a series of YAML and Ruby faults to gain privileged access in the machine. It's quick, it's simple, it's fun!

Overall, this machine was far easier than I expected. It took a bit of digging for some of the exploits as they're not all publicized at this time, but using github was easy. You can use the documents below for information.

Have fun with this one!


<h2> Documentation </h2>

• <b>PDFKIT 0.8.6 EXPLOIT</b> https://security.snyk.io/vuln/SNYK-RUBY-PDFKIT-2869795

• <b>REVERSE SHELL MAKER</b> https://www.revshells.com/

• <b>YAML DESERIALIZATION</b> https://book.hacktricks.xyz/pentesting-web/deserialization/python-yaml-deserialization

• <b>YAML PAYLOAD</b> https://gist.github.com/staaldraad/89dffe369e1454eedd3306edc8a7e565#file-ruby_yaml_load_sploit2-yaml

<h2> Walkthrough </h2>

Merry Christmas! We start this machine off by enumerating all ports. It's quick, we get both SSH and HTTP open. So we head over to the webfront after inputting the web address into our hosts file.
![image](https://user-images.githubusercontent.com/115663211/209872937-6935a35a-7bb6-42c1-806d-336bbb026cd3.png)

The web front is presented to us with little there. It requests a URL to make a PDF.

![image](https://user-images.githubusercontent.com/115663211/209873530-06bcf004-c1e2-42da-9eae-c8b52f39c253.png)

By hosting a webserver using python on 8080, we get a valid request that lists all of the folders in my machine from the hosting point of the python server. This is good, let's expand the metadata and see what we can find from the file.

![image](https://user-images.githubusercontent.com/115663211/209873676-9d861ca6-e096-4d15-b27c-2c4212b971b7.png)

PDFKit was used to create this PDF. While that might not mean all that much just from a glance, we can search up on google and find that there is an exploit for this.

![image](https://user-images.githubusercontent.com/115663211/209873827-f1744c3a-60b1-4a8b-9c54-1997abe54195.png)

Okay, great. So we can use the link in the documentation above as a template for making our payload. We spin up a NC on 4445 as a test, then create our template payload in our URL.

![image](https://user-images.githubusercontent.com/115663211/209873957-0cd47cb1-a4b2-49cb-9859-0513faef580f.png)

This template can be used with our URL to make this:

![image](https://user-images.githubusercontent.com/115663211/209874265-b8b82363-0fd5-4143-a7f7-08f52f539248.png)

By creating a bash revere shell using the amazing www.revshells.com we were then able to successfully get a connection as user 'ruby.' Let's start by enumerating the local filespace and see what we can find.

![image](https://user-images.githubusercontent.com/115663211/209874475-88142cfe-4a76-468e-a3bb-6b8f1a23ccd3.png)

Both .bundle and .profile stick out. I check bundle, find a config file and some nice little credentials in there.

![image](https://user-images.githubusercontent.com/115663211/209874516-7c703372-6be2-4f1e-a1c5-ed6125d7eefa.png)

This must be our entry to the user flag. It also looks like a hash from a glance, but in reality it's just a gross password. So, we can drop out of our reverse shell and connect via ssh as henry.

![image](https://user-images.githubusercontent.com/115663211/209874617-e633131f-7e93-41d9-b326-37c469a56abe.png)

We're in as henry! That's step one of the machine, now we just get the user flag, then work on elevating up to root. Let's see what we can run with elevated root access from here.

![image](https://user-images.githubusercontent.com/115663211/209874733-de69893a-bba2-42f6-b4d3-07a9e04596a4.png)

So we can run a ruby file with root privileges. Okay, cool. So what can we do with this? Let's find out. We can open up the file, see what exactly we're playing with here.

![image](https://user-images.githubusercontent.com/115663211/209874869-eb765282-9cbe-4d11-87c5-90a51e4b5c7f.png)

Inside our ruby file, we can find a little file called 'dependencies.yml.' .. This is great. This is our way in. We can create a dud dependencies file of our own, inject some malicious code in there with ruby and try to create an elevated shell. We can take a shell creator made by another user (linked above in the documents) and inject that into our dependencies file.

![image](https://user-images.githubusercontent.com/115663211/209875636-857ac6b4-f54e-4667-a0b7-ba34cf3baa64.png)

By modifying just a snippet of code in the original creation, we can run this ruby script and see what comes of it.

![image](https://user-images.githubusercontent.com/115663211/209876756-85a419c7-6e04-4489-902e-32c1d88b0794.png)

We now have root. We can go ahead, pinch the root flag, call it a day. This machine was pretty interesting, changing the permissions of the bash binary itself is something I've not done before.

<h2> Closing Remarks </h2>

This machine was a particularly interesting one. The biggest gripe I have with this is the introduction of Ruby, but you can find all the exploits needed online with a simple google search. Nothing to break my toes.


