const moment = require('moment')

const express = require('express')
const app = express()
app.set('view engine', 'pug')

app.listen(3000, _ => {
  console.log(`listening on ${3000}`)
})

app.get('/', (_req, res) => {
  // load medias

  res.render('index', { title: 'Hey', message: 'Hello there!' })
})