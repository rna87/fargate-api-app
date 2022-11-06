const express = require("express");
const bodyParser = require('body-parser');
const fs = require('fs');

var metadata = JSON.parse(fs.readFileSync('metadata.json', 'utf8'))

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Enable CORS for all methods
app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
    next()
});

app.get("/", async (req, res, next) => {

    try {
        res.contentType("application/json").send({ 
            "Hello World! you are visotry number:": Math.floor(Math.random() * 101) 
        })
    } catch (err) {
        next(err);
    }
});

// status page
app.get('/status', (req, res) => {

    try {
        let output = {
            [metadata.app]: [{
                "version": metadata.version,
                "description": metadata.description,
                "sha": process.env.LASTCOMMIT
            }]
        }
        res.status(200).send(output)
    } catch (err) {
        res.status(400).send(err)
    }
})

app.listen( () => {
    console.log('This '+ metadata.app +' is listening at '+ process.env.URL);
});