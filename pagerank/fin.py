import os
import webbrowser
import subprocess
subprocess.call(" python spider.py", shell=True)
print "Calculating Rank ....... "
subprocess.call(" python sprank.py", shell=True)
print "Dump File "
subprocess.call(" python spdump.py", shell=True)
s=os.getcwd()+'/force.html'
webbrowser.open_new(s)

