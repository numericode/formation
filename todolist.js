var express = require('express');
var session = require('cookie-session');
var url = require('url');
var QS = require('querystring');
var application = express();

/* On utilise les sessions */
application.use(session({secret: 'todotopsecret'}))

/* S'il n'y a pas de todolist dans la session,
on en crée une vide sous forme d'array avant la suite */
.use(function(req, res, next){
    if (typeof(req.session.todolist) == 'undefined') {
        req.session.todolist = [];
        req.session.wholist = [];
    }
    next();
});


application.get('/delete/:id', function(req, res){
	if(req.params.id != null){
	req.session.todolist.splice(req.params.id, 1);
	req.session.wholist.splice(req.params.id, 1);
	}
	res.redirect('/listtask');
})

.get('/add', function(req, res){
	var params = QS.parse(url.parse(req.url).query);
	if(params['newtodo'] != null && params['newtodo']!=''){
		req.session.todolist.push(params['newtodo']);
		req.session.wholist.push(params['who']);
	}	
	res.redirect('/listtask');
})
.get('/wholist', function(req, res){
		req.session.todolist.push(req.session.wholist);
	res.redirect('/listtask');
})
.get('/up/:id', function(req, res){
	if(req.params.id != null && req.params.id > 0){
		swap(req.session.todolist, parseInt(req.params.id), parseInt(req.params.id)-1);
		swap(req.session.wholist, parseInt(req.params.id), parseInt(req.params.id)-1);
//		var temp = req.session.todolist[req.params.id - 1];
//		req.session.todolist[req.params.id - 1] = req.session.todolist[req.params.id];
//		req.session.todolist[req.params.id] = temp;
//		var tempwho = req.session.wholist[req.params.id - 1];
//		req.session.wholist[req.params.id - 1] = req.session.wholist[req.params.id];
//		req.session.wholist[req.params.id] = tempwho;
	}
	res.redirect('/listtask');
})
.get('/down/:id', function(req, res){
	if(req.params.id != null && req.params.id < req.session.todolist.length - 1){
		swap(req.session.todolist, parseInt(req.params.id), parseInt(req.params.id)+1);
		swap(req.session.wholist, parseInt(req.params.id), parseInt(req.params.id)+1);
//		var temp = req.session.todolist[parseInt(req.params.id) + 1];
//		req.session.todolist[parseInt(req.params.id) + 1] = req.session.todolist[req.params.id];
//		req.session.todolist[req.params.id] = temp;
//		var temp = req.session.wholist[parseInt(req.params.id) + 1];
//		req.session.wholist[parseInt(req.params.id) + 1] = req.session.wholist[req.params.id];
//		req.session.wholist[req.params.id] = temp;
	}
	res.redirect('/listtask');
})
.get('/selectbox/:id/:name', function(req, res){
	if(req.params.id != null && req.params.name != null){
		//console.log('before - ' + req.session.wholist[parseInt(req.params.id)]);
		req.session.wholist[parseInt(req.params.id)] = req.params.name;
		//console.log('after - ' + req.session.wholist[parseInt(req.params.id)]);
	}
	res.writeHead(200);
	res.end();
})
.get('/listtask', function(req, res){
	res.render('todolist.html.twig', { "todolist" : req.session.todolist, "wholist" : req.session.wholist});
})

.get('/clear', function(req, res){
        req.session.todolist = [];
        req.session.wholist = [];
	res.redirect('/listtask');
})

.use(function(req, res, next){
	res.redirect('/listtask');
});
function swap(table, fromId, toId){
	var temp = table[fromId];
	table[fromId] = table[toId];
	table[toId]=temp;
}

application.listen(8088);