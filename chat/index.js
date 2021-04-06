const express = require('express');
const app = express();
app.use(express.static('public'));
const server = require('http').createServer(app);
const io = require('socket.io')(server);
io.on('connection', socket => {
    console.log("New user connected");
    io.emit('socketClientID', socket.id);
    socket.on('chat message', msg => {
        console.log(msg);
        io.sockets.emit('chat message', msg);
    });
   socket.on('joined', msg => {
        console.log(msg);
        io.sockets.emit('joined', msg);
        socket.on('disconnect', function() {
            io.sockets.emit('left', msg);
        });
    });
});
server.listen(3000);