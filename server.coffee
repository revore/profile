http = require("http")
fs = require("fs")

serveIndex = (req, res) ->
  if req.url == "/app.js"
    res.setHeader("content-type", "text/javascript")
    path = req.url.slice(1)

  else if req.url == "/app.css"
    res.setHeader("content-type", "text/css")
    path = req.url.slice(1)

  else
    path = "index.html"

  res.writeHead 200
  res.end fs.readFileSync(path)

port = process.env.PORT || "6060"
http.createServer(serveIndex).listen port
