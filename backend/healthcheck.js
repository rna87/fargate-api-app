const express = require("express");
const bodyParser = require('body-parser');
const fs = require('fs');
const port = process.env.PORT || 3001;


const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Enable CORS for all methods
app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
    next()
});

app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
    next()
});

// healthcheck
app.get('/health', (resp) => {
    if (resp.statusCode === 200) process.exit(0);
    else process.exit(1);
})