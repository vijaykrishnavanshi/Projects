from flask import (
    request,
    redirect,
    url_for,
    Flask,
    render_template,
    flash,
    session,
)

from data import (
    enteruser,
    adduser,
    addshare,
    validateno,
    finduser,
    removeshare,
    listplayers,
    listbidders,
    activate,
)

app=Flask(__name__)
app.secret_key= "what's up!"

admin = ['pulkit', 'vijay', 'akshita', 'mohit']

@app.route('/')
def first():
	return redirect(url_for('login'))

@app.route('/login', methods=['POST','GET'])
def login():
    if session.has_key("username"):
        return redirect(url_for('dashboard', uname = session['username']))
    if request.method == 'GET':
	return render_template('login.html', title="Login | Players")
    elif request.method == 'POST':
        name = request.form['lg_username'].lower()
        if ' ' in name:
            flash("Don't use space in usernames")
            return redirect(url_for('signup'))
        passw = request.form['lg_password']
        ret = enteruser([name, passw])
        if ret == 0: #Succesfull Login
            session['username'] = name
            return redirect(url_for('dashboard', uname = name)) 
        elif ret == 1: #Passwords don't match
            flash("Incorrect password")
            return redirect(url_for('login'))
        elif ret == 2: #User not found
            flash("Username not found")
            return redirect(url_for('login'))
        elif ret == 3: #Not activated
            flash("Account not activated")
            return redirect(url_for('login'))

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if session.has_key("username"):
        return redirect(url_for('dashboard', uname = name))
    if request.method == 'GET':
	return render_template('signup.html', title="Signup | Players")
    elif request.method == 'POST':
        name = request.form['reg_name']
        username = request.form['reg_username'].lower()
        entryno = request.form['reg_entryno']
        passw = request.form['reg_password']
        cpassw = request.form['reg_password_confirm']
        if not passw == cpassw:
            flash("bhand hai kya, password hi dono alag hai")
            return redirect(url_for('signup'))
        validate = validateno(entryno)
        if not validate:
            flash("Invalid Entry No.")
            return redirect(url_for('signup'))
        ret = adduser([name, username, validate, passw])
        if ret == 0: #Sucessful Signup
            flash("Signed up successfully")
            return redirect(url_for('login'))
        elif ret == 1:
            flash("Username exists, try using a different username")
            return redirect(url_for('signup'))
        else:
            flash("Entry No. exists")
            return redirect(url_for('signup'))

@app.route('/user/<uname>')
def dashboard(uname):
    uname = uname.lower()
    res = finduser(uname)
    if not res:
        return "User not found in database"
    if not session.has_key("username"):
        return render_template('user-dashboard.html', username = uname,\
                            title = (uname+" | Players"), fullname = res[0],\
                            entryno = res[1], pvalue = res[2], bvalue = res[3],\
                            bidders = res[4], playing = res[5])

    if uname == session['username']:
        return render_template('user-dashboard.html', username = uname, lg_username = uname,\
                            title = "Dashboard | Players", fullname = res[0],\
                            entryno = res[1], pvalue = res[2], bvalue = res[3],\
                            bidders = res[4], playing = res[5])

    return render_template('user-dashboard.html', username = uname,\
                            lg_username = session['username'],\
                            title = (uname+" | Players"), fullname = res[0],\
                            entryno = res[1], pvalue = res[2], bvalue = res[3],\
                            bidders = res[4], playing = res[5])

@app.route('/rules')
def help():
    if not session.has_key("username"):
        return render_template('rules.html', title = "Rules | Players")
    return render_template('rules.html', lg_username = session['username'], title = "Rules | Players")

@app.route('/players')
def players():
    if not session.has_key("username"):
        rls = listplayers()
        return render_template('players.html',\
                        title = "Players Leaderboard", players = zip(rls[0],rls[1],rls[2]))
    rls = listplayers(session['username'])
    return render_template('players.html', lg_username = session['username'],\
                        title = "Players Leaderboard",\
                        players = zip(rls[0], rls[1], rls[2]))

@app.route('/bidders')
def bidders():
    if not session.has_key("username"):
        return render_template('bidders.html', players = listbidders(),\
                        title = "Bidders Leaderboard")
    return render_template('bidders.html', lg_username = session['username'],\
                        players = listbidders(), title = "Bidders Leaderboard")

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for("login"))

@app.route('/purchase/<user>buys<player>')
def purchase(user, player):
    if not session.has_key('username'):
        return "Login First"
    if session['username'] != user:
        return "Acess Denied"
    ret = addshare(user, player)
    if ret == 0:
        return redirect(url_for('dashboard', uname = user))
    if ret == 1:
        return "Kaahe explicitly request maar rahe ho, share pada to hai"
    elif ret == 2:
        return "Bhai explicitly request maarne se kch nahi hoga, aake rupay de point le"

@app.route('/sell/<user>sells<player>')
def sell(user, player):
    if not session.has_key('username'):
        return "Login First"
    if session['username'] != user:
        return "Mana beta hacker ho, par yahan nahi, yahan papa hai"
    ret = removeshare(user, player)
    if ret == 0:
        return redirect(url_for('dashboard', uname = user))
    if ret == 1:
        return "maana hacker ho, par ye nahi pata jo cheez hoti hi nahi wo kaise hategi"

@app.route('/activate', methods=['POST', 'GET'])
def activateuser():
    if not session.has_key('username'):
        return "Acess denied"
    if session['username'] in admin:
        if request.method == 'GET':
            return render_template('activate.html')
        elif request.method == 'POST':
            user = request.form['username']
            ret = activate(user, session['username'])
            if ret == 0:
                return redirect(url_for('activateuser'))
            elif ret == 1:
                return "Activated hai bhai"
            return "Signup kiye ho?"
    return "Rupiya to dena padega babu"

@app.route('/update', methods=['POST', 'GET'])
def updatevalue():
    if not session.has_key('username'):
        return "Acess denied"
    if session['username'] in admin:
        if request.method == 'GET':
            return render_template('update.html')
        elif request.method == 'POST':
            user = request.form['username']
            value = request.form['value']
            ret = activate(user, value)
            if ret == 0:
                return redirect(url_for('updatevalue'))
            elif ret == 1:
                return "User not found"
            return "Pata nahi kya hogaya"
    return "Aisa na hoga beta update"

#if __name__ == "__main__":
#    app.run(debug=True)
