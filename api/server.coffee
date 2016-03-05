polar = require 'polar'

app = polar port: 4748, debug: true

app.get '/', (req, res) -> res.render 'app'

app.start()
