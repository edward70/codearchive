const Discord = require("discord.js");
const express = require('express');
var mustacheExpress = require('mustache-express');
var request = require("request");
const client = new Discord.Client();
const app = express();
const port = 3000;
const myurl = "https://cat-pic-bot.now.sh";

client.on("ready", () => {
  console.log('I am alive!');
});

// Low is inclusive, high is exclusive
function randomInt(low, high) {
    return Math.floor(Math.random() * (high - low) + low)
}

var messages = [
    "Enjoy!",
    "Have fun!",
    ":)",
    "You can thank me later",
    "Meow!",
    ":cat:",
    ":heart_eyes_cat:",
    ":joy_cat:",
    ":kissing_cat:",
    ":smile_cat:",
    ":smiley_cat:"
];

var requests = 0;
var lastRequested = "https://via.placeholder.com/720x480?text=None+requested+yet";

client.on("message", (message) => {
  if (message.content.toLowerCase().startsWith("cat") || message.content.startsWith("🐱")) {
    requests++;
    message.react("🐱");
    request({ url: "https://source.unsplash.com/featured/?cat,kitten,cats,kittens,kitties", followRedirect: false }, function (err, res, body) {
      lastRequested = res.headers.location;
      message.reply(messages[randomInt(0,messages.length)] + ' \n' + res.headers.location);
    });
  } else if (message.isMentioned(client.user)) {
    message.react("😻");
    message.reply("To check out my stats or add me to your server go to " + myurl);
  }
});

client.login(process.env.TOKEN);

app.engine("mustache", mustacheExpress());
app.set('view engine', 'mustache')
app.get('/', function (req, res) {
    res.render('index', { requested: requests, last: lastRequested })
})
app.listen(port, () => console.log(`Express app listening on port ${port}`))
