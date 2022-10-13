<h1> Illumination </h1>

An <b>EASY</b> Challenge.

<h4> Summary </h4>
This challenge involves understanding how github and git functions within linux. The aim is to find a secret 'key', which can be found by looking through a hidden folder and examining commit history.

<h2> Documentation </h1>

<b> GIT LOG AND GIT HISTORY </b> https://linuxhint.com/view-the-commit-history-of-the-git-repository/#:~:text=%60git%20log%60%20command%20is%20used,commit%20will%20be%20displayed%20first.

<h2> Walkthrough </h2>

We're first presented with the zip file itself. I created a folder for this challenge and went ahead and unzipped the file. Presenting us with two files, plus a hidden one.

![image](https://user-images.githubusercontent.com/115663211/195667116-2516aba1-2095-4492-a0ff-fd60ec6286aa.png)

The .git folder looks interesting. After researching, it's possible to check what's inside of the folder and see the previous commit history. And so, we do that first.

![image](https://user-images.githubusercontent.com/115663211/195667291-96a29103-ee73-4340-a8b1-2bd507d2004c.png)

This commit is pretty interesting. We can back out of this and see the commit in full by using 'git show' ... Which provides us with this following bit of information.

![image](https://user-images.githubusercontent.com/115663211/195667578-9081e919-c414-48f1-a517-b92a506c61bd.png)

A token. Decrypting this was made easy by the '=' at the end of the line, which tipped me off as it being a base64 encode. Decoding this gets us to the flag, and voila!

