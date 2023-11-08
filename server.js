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
  years = [...new Set(years)].sort((x, y) => y - x)

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
           .sort((x, y) => y.date > x.date ? 1 : -1)
}

const mediaTypes = {
  photo: ['jpg', 'jpeg'],
  video: ['mp4', 'mov'],
  audio: ['mp3'],
  text: ['txt'],
}

const extensionToType = {}
for (const [type, extensions] of Object.entries(mediaTypes)) {
  for (const extension of extensions) {
    extensionToType[extension] = type
  }
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

  const extension = fileName.toLowerCase().split('.').pop()
  media.type = extensionToType[extension]

  return media
}
