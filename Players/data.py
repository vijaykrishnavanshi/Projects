from pymongo import MongoClient
client = MongoClient()
db = client['app']
colbid = db['bidder']

'''Each user will have the following data stored in database:
* A unique username stored with key 'Username'
* Full name stored with key 'Name'
* Entry No stored with key 'Entry No'
* Account password stored with key 'Password'
* A playing value stored with key 'PValue'
  The playing value will be initialized with 70.
* A bidding value stored with key 'BValue'
  The bidding value stored will be initialized with 200.
* Three usernames on which the user has bid on.
  It will be a tuple, with checks to done to keep it of size 3.
  It will be stored with key 'BUsers'
* Events in which he/she secured top three positions.
  It will be also a tuple.
  It will be stored with key 'PEvents'
'''

admin = ['pulkit', 'mohit', 'vijay', 'akshita']

def adduser(dic):
    '''helps in the signup task. Add a new user to our database but before doing
that checks whether the username is used by someone else or not. Also
checks whether we have an account by that entry number or not.
Returns 0 on succesfull insertion, 1 if username is already in use
and 2 if the entry no. has an account previously.'''

    con = colbid.find_one({"Username": dic[1]})
    if con:
        return 1 #Username exists
    if colbid.find_one({"Entry No": dic[2]}):
        return 2 #Entry No. exists
    diction = {"Name": dic[0], "Username": dic[1], "Entry No": dic[2],\
                "Password": dic[3], "PValue": meanpvalue(), "BValue": 200,\
                "BUsers": [], "PEvents":[], "Activated": False, "Aby":'',\
                "BAvg": 0}
    colbid.insert_one(diction)
    return 0 #Successful insertion

def removeuser(name):
    '''This function will remove the user from our database. It is not used
anywhere but can be called explicitly whenever needed.'''
    colbid.remove({"Username": name})

def activate(name, activater):
    '''Each user has to get the account activated before using it. So this
function activates the account by setting the Activated value to True. It is
redirected to /activate and is accessible only to admins.'''
    rs = colbid.find_one({"Username":name})
    if not rs:
        return 2
    if rs['Activated'] == True:
        return 1
    colbid.update_one({"Username":name},{'$set':{'Activated':True, 'Aby':activater}})
    return 0 #succesfull update

def meanpvalue():
    '''It calculates the mean of PValues in our database to assign new user
a PValue. Each new user is assigned a PValue equal to the mean of current
market value. This is called when we insert a user in our database.'''
    sumvalues = 0
    num = 0
    for each in colbid.find():
        sumvalues+= each['PValue']
        num+= 1
    if num == 0 or sum == 0:
        return 70
    return (sumvalues/num)

def updatebvalue(user, value):
    '''Updates the BValue of the user by a given amount. This function is used
when a user wants to get his bidding value increased. It is rendered at /update
and is acessible only by the admins.'''
    rs = colbid.find_one({"Username":user})
    if not rs:
        return 1	#User not found
    curvalue = colbid.find_one({'Username':user})['BValue']
    curvalue = curvalue + value
    colbid.update_one({'Username':user}, {'$set':{'BValue':curvalue}})
    return 0

def enteruser(dic):
    '''helps in the login task. Check whether the username and password are
correct or not. Returns 0 if creditientals are right. Returns 1 if
passwords are not equal. Returns 2 if user not found.'''

    name = dic[0]
    password = dic[1]
    rs = colbid.find_one({"Username":name})
    if not rs:
        return 2	#user not found
    if not rs['Activated']:
        return 3	#Account no activated
    if rs["Password"]==password:
        return 0	#Succesful login
    elif rs["Password"]!=password:
        return 1	#Passwords don't match
    else:
        return 2	#User not found

def finduser(name):
    '''Find a user whether it exists in our database and if it do, this function
returns its related data which are required to show on his profile page.
Returns False if the user does not exists.'''

    rs = colbid.find_one({"Username":name})
    if rs:
        return [rs['Name'], rs['Entry No'], rs['PValue'], rs['BValue'], rs['BUsers'], rs['PEvents']]
    return False

def listplayers(user=None):
    '''hello'''
    ls = []
    for val in colbid.find().sort("PValue"):
        if not val['Username'] in admin:
            ls.append(val)
    rls = [a["Username"] for a in ls]
    rpv = [a["PValue"] for a in ls]
    ret = []
    ret.append(rls)
    ret.append(rpv)
    if user:
        usersh = colbid.find_one({'Username':user})
        usershares = usersh['BUsers']
        userbalance = usersh['BValue']
        rshare = [0 if a["Username"] in usershares else ( 1 if a['PValue'] > userbalance else 2) for a in ls]
        ret.append(rshare)
        return ret
    rshare = [True for a in ls]
    ret.append(rshare)
    return ret

def listbidders():
    '''hello'''
    ls=[]
    for val in colbid.find().sort("BAvg"):
        if not val['Username'] in admin:
            ls.append(val)
    rls = {a["Username"]:a["BAvg"] for a in ls}
    return rls

def addshare(bidder, player):
    '''It adds a new share of the player to the bidders list. The amount of the
share of that player will be deducted from his bidding points. Share is not
added if the bidder already has the share or has insufficient balance. It is
called by the plus sign in the UI.'''
    entry = colbid.find_one({"Username":bidder})
    curbid = entry["BValue"]
    curvalue = entry['BUsers']
    pvalue = colbid.find_one({"Username":player})['PValue']
    if pvalue > curbid:
        return 2 #don't have much amount  
    if player in curvalue:
        return 1 #share exists
    curvalue.append(player)
    colbid.update_one({"Username":bidder},{'$set':{'BUsers':curvalue,\
                        'BValue':(curbid-pvalue)}})
    sharesavg(bidder)
    return 0 #successful updates

def removeshare(bidder, player):
    '''It removes the share of the player from the bidder's shares list. The
current market amount of that share is added to the bidder's bidding points.
Returns 1 if the share don't exists. This is called after clicking the minus
sign from the UI.'''
    entry = colbid.find_one({"Username":bidder})
    curbid = entry["BValue"]
    curvalue = entry['BUsers']
    pvalue = colbid.find_one({"Username":player})['PValue']
    if not player in curvalue:
        return 1 #share don't exists
    curvalue.remove(player)
    colbid.update_one({"Username":bidder},{'$set':{'BUsers':curvalue,\
                        'BValue':(curbid+pvalue)}})
    sharesavg(bidder)
    return 0 #sucessful removal

def sharesavg(user):
    '''doc'''
    usdata = colbid.find_one({'Username':user})['BValues']
    total = 0
    count = 0
    for a in usdata:
        player = colbid.find_one({'Username':a})['PValue']
        total+= player
        count = count + 1
    avg = (total/count) + (0.5*count)
    colbid.update_one({'Username':user},{'$set':{'BAvg':avg}})

def validateno(num):
    '''Validates an entry number and convert it to a general format. We have a list
of entry numbers which are used in the university. Older entry numbers start
with 2013 or 2012 where new ones are like 14.., 15..., 16....
The functon returns False if the entry number is not valid.'''

    threear = ["ecs", "bcs", "eec", "bec", "eme", "bme", "ebt", "bib", "eal", "bar", "bal", "men", "mbt",\
                "mmm", "mpy", "mms", "mmc", "mma", "mca", "ies", "mmb",\
                "dcs", "dec", "dmt", "dln", "dph", "dbu", "dbt", "dem", "dme", "dse"]
    sixar = ["phdsob", "phdsbt", "phdecs", "phdeec", "phdsol"]
    res = ""
    if num.startswith('2012') or num.startswith('2013'):
        res = num[0:4]
        if num[4:7].lower() in threear:
            try:
                int(num[7:])
            except:
                return False
            res+=num[4:7].lower()
            if len(num[7:]) > 3:
                return False
            if len(num[7:]) == 2:
                return (res+"0"+num[7:])
            if len(num[7:]) == 1:
                return (res+"00"+num[7:])
            return (res+num[7:])
        elif num[4:10].lower() in sixar:
            try:
                int(num[10:])
            except:
                return False
            res+=num[4:10].lower()
            if len(num[10:]) > 3:
                return False
            if len(num[10:]) == 2:
                return (res+"0"+num[10:])
            if len(num[10:]) == 1:
                return (res+"00"+num[10:])
            return (res+num[10:])
        else:
            return False

    elif num.startswith('14') or num.startswith('15') or num.startswith('16'):
        res = num[0:2]
        if num[2:5].lower() in threear:
            try:
                int(num[5:])
            except:
                return False
            res+=num[2:5].lower()
            if len(num[5:]) > 3:
                return False
            if len(num[5:]) == 2:
                return (res+"0"+num[5:])
            if len(num[5:]) == 1:
                return (res+"00"+num[5:])
            return (res+num[5:])
        elif num[2:8].lower() in sixar:
            try:
                int(num[8:])
            except:
                return False
            res+=num[2:8].lower()
            if len(num[8:]) > 3:
                return False
            if len(num[8:]) == 2:
                return (res+"0"+num[8:])
            if len(num[8:]) == 1:
                return (res+"00"+num[8:])
            return (res+num[8:])
        else:
            return False

    else:
        return False
