(function () {
    var socket = io();

    var screen1 = document.getElementById('screen1');
    var screen2 = document.getElementById('screen2');

    var nameinput = document.getElementById('nameinput');
    var namesubmit = document.getElementById('namesubmit');
    var name;

    namesubmit.addEventListener('click', function() {
        if (nameinput.value.trim() != "") {
            name = nameinput.value;
            screen1.style.display = 'none';
            screen2.style.display = 'flex';
            socket.emit('joined', name);
        }
    }, false);

    socket.on('socketClientID', function (socketClientID) {
        console.log('Connection to server established. SocketID is', socketClientID);
    });

    var chatbox = document.getElementById('chatbox');
    var submit = document.getElementById('submit');

    chatbox.addEventListener('keypress', function(event) {
        if (event.which === 13 && chatbox.value.trim() != '') {
            socket.emit('chat message', { message: chatbox.value, name: name });
            chatbox.value = '';
            event.preventDefault();
        }
    }, false);

    submit.addEventListener('click', function() {
       if (chatbox.value.trim() != '') {
            socket.emit('chat message', { message: chatbox.value, name: name });
            chatbox.value = '';
       }
    }, false);

    var chat = document.getElementById('chat');
    var md = new Remarkable();

   chat.addEventListener("scroll",function(){
       window.lastScrollTime = new Date().getTime()
   });
   function is_scrolling() {
       return window.lastScrollTime && new Date().getTime() < window.lastScrollTime + 500
   }

    socket.on('chat message', function (msg) {
        var elem = document.createElement('div');
        var nametag = document.createElement('div');
        var nametagname = document.createElement('b');
        nametagname.textContent = msg.name;
        nametag.appendChild(nametagname);
        elem.appendChild(nametag);
        var text = document.createElement('div');
        text.innerHTML = md.render(msg.message);
        text.classList.add('text');
        elem.appendChild(text);
        elem.classList.add('message');
        chat.appendChild(elem);
        if (!is_scrolling()) {
            chat.scrollTop = chat.scrollHeight;
        }
    });

    socket.on('joined', function (person) {
        var elem = document.createElement('div');
        elem.textContent = person + " has joined the chat.";
        elem.classList.add('message');
        chat.appendChild(elem);
    });

   socket.on('left', function (person) {
        var elem = document.createElement('div');
        elem.textContent = person + " has left the chat.";
        elem.classList.add('message');
        chat.appendChild(elem);
    });
})();