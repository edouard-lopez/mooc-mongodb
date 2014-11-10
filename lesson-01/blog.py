# -*- coding: utf-8 -*-

import bottle, pymongo

@bottle.route('/')
def index():
    my_things = ['pomme', 'lait', 'fromage']
    return  bottle.template('index.html', username='ed8', things=my_things)

@bottle.route('/newpost')
def newpost():
    pass

@bottle.route('/post')
def post():
    pass

@bottle.route('/login')
def login():
    pass

@bottle.route('/logout')
def logout():
    pass

@bottle.route('/tags')
def tag():
    pass

bottle.debug(True)
bottle.run(host='localhost', port=8080, reloader=True)
