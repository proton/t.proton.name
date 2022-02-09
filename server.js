const CONTENT_DIRECTORY = '/content'
const PREVIEWS_DIRECTORY = CONTENT_DIRECTORY + '/previews'

const fs = require('fs')
const express = require('express')
const app = express()
app.use(express.static('public'))
app.set('view engine', 'pug')

app.listen(3000, _ => {
  console.log(`listening on ${3000}`)
})

app.get('/', async (_req, res) => {
  const medias = await loadMedia()

  let years = medias.map(m => m.year)
  years = [...new Set(years)].sort((x, y) => x - y)

  res.render('index', { medias: medias, years: years })
})

app.get('/media/:fileName', async (req, res) => {
  if (req.params.fileName.startsWith('.')) return
  res.set('Cache-control', 'public, max-age=30000000')
  res.sendFile(CONTENT_DIRECTORY + '/' + req.params.fileName)
})

app.get('/preview/:fileName', async (req, res) => {
  if (req.params.fileName.startsWith('.')) return
  res.set('Cache-control', 'public, max-age=30000000')
  res.sendFile(PREVIEWS_DIRECTORY + '/' + req.params.fileName)
})

const loadMedia = async (_) => {
  return fs.readdirSync(CONTENT_DIRECTORY)
           .map(mapMedia)
           .filter(x => x)
           .filter(x => x.type)
           .sort((x, y) => x.date > y.date ? 1 : -1)
}

const mapMedia = (fileName) => {
  const media = {
    url: '/media/' + fileName,
    preview: '/preview/' + fileName,
    name: fileName,
    date: fileName.slice(0, 10),
    year: +fileName.slice(0, 4),
    isHidden: fileName.includes("hidden")
  }
  const lowerCasedFileName = fileName.toLowerCase()
  if (lowerCasedFileName.endsWith("jpg")) media.type = "photo"
  else if (lowerCasedFileName.endsWith("jpeg")) media.type = "photo"
  else if (lowerCasedFileName.endsWith("mp4")) media.type = "video"
  else if (lowerCasedFileName.endsWith("mp3")) media.type = "audio"
  else if (lowerCasedFileName.endsWith("txt")) media.type = "text"

  return media
}
