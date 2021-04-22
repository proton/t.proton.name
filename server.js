const moment = require('moment')

const axios = require('axios').default

const express = require('express')
const app = express()
app.use(express.static('public'))
app.set('view engine', 'pug')

app.listen(3000, _ => {
  console.log(`listening on ${3000}`)
})

app.get('/', async (_req, res) => {
  const yandexDiskToken = process.env.YANDEX_DISK_TOKEN
  const yandexDiskVideoPath = process.env.YANDEX_DISK_VIDEO_PATH
  const yandexDiskAudioPath = process.env.YANDEX_DISK_AUDIO_PATH
  const yandexDiskPhotoFullPath = process.env.YANDEX_DISK_PHOTO_PREVIEW_PATH
  const yandexDiskPhotoPreviewPath = process.env.YANDEX_DISK_PHOTO_FULL_PATH

  const videos = await loadVideos(yandexDiskToken, yandexDiskVideoPath)
  const audios = await loadAudios(yandexDiskToken, yandexDiskAudioPath)
  const photos = await loadPhotos(yandexDiskToken, yandexDiskPhotoFullPath, yandexDiskPhotoPreviewPath)

  const medias = [].concat(videos, audios, photos)
  // medias = medias.sort_by { |m| m["date"].to_s }.reverse

  // years = medias.map { |m| m["year"] }.uniq
  const years = [1988, 2020]
  

  res.render('index', { medias: medias, years: years })
})

const loadYandexDiskFiles = async(token, path) => {
  const response = await axios.get('https://cloud-api.yandex.net/v1/disk/resources', {
    params: { path: path, limit: 1000 },
    headers: {'Accept': 'application/json', 'Authorization': `OAuth ${token}`}
  })

  return response.data._embedded.items
}

const loadVideos = async (token, path) => {
  const json = await loadYandexDiskFiles(token, path);
  return json.map(x => {
    return {
      type: "video",
      url: x.file,
      name: x.name,
      preview: x.preview,
      date: x.name.slice(0, 10),
      year: +x.name.slice(0, 4),
      isHidden: x.name.includes("hidden")
    }
  })
}

const loadAudios = async (token, path) => {
  const json = await loadYandexDiskFiles(token, path);
  return json.map(x => {
    return {
      type: "audio",
      url: x.file,
      name: x.name,
      date: x.name.slice(0, 10),
      year: +x.name.slice(0, 4),
      isHidden: x.name.includes("hidden")
    }
  })
}

const loadPhotos = async (token, originalsPath, previewsPath) => {
  const jsonOriginals = await loadYandexDiskFiles(token, originalsPath)
  const jsonPreviews = await loadYandexDiskFiles(token, previewsPath)

  const originals = Object.assign({}, ...jsonOriginals.map((x) => ({[x.name]: x})));

  return jsonPreviews.map(x => {
    const url = originals[x.name].file

    return {
      type: "photo",
      url: url,
      name: x.name,
      preview: x.file,
      date: x.name.slice(0, 10),
      year: +x.name.slice(0, 4),
      isHidden: x.name.includes("hidden")
    }
  })
}