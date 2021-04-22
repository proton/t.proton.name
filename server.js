const moment = require('moment')

const express = require('express')
const app = express()
app.use(express.static('public'))
app.set('view engine', 'pug')

app.listen(3000, _ => {
  console.log(`listening on ${3000}`)
})

app.get('/', (_req, res) => {
  const yandexDiskToken = process.env.yandexDiskTOKEN
  const yandexDiskVideoPath = process.env.yandexDiskVIDEO_PATH
  const yandexDiskAudioPath = process.env.yandexDiskAUDIO_PATH
  const yandexDiskPhotoFullPath = process.env.yandexDiskPHOTO_FULL_PATH
  const yandexDiskPhotoPreviewPath = process.env.yandexDiskPHOTO_PREVIEW_PATH

  const videos = loadVideos(yandexDiskToken, yandexDiskVideoPath)
  const audios = loadAudios(yandexDiskToken, yandexDiskAudioPath)
  const photos = loadPhotos(yandexDiskToken, yandexDiskPhotoFullPath, yandexDiskPhotoPreviewPath)

  const medias = videos.concat(audios, photos)
  // medias = medias.sort_by { |m| m["date"].to_s }.reverse

  // years = medias.map { |m| m["year"] }.uniq
  const years = [1988, 2020]
  

  res.render('index', { medias: medias, years: years })
})

const loadVideos = () => { return [] }
const loadAudios = () => { return [] }
const loadPhotos = () => { return [] }

/*
  def load_videos(token, path)
    load_yandexDiskfiles(token, path).map do |x|
      name = x["name"].as_s
      {
        "type" => "video",
        "url" => x["file"],
        "name" => name,
        "preview" => x["preview"],
        "date" => name[0...10],
        "year" => name[0...4],
        "is_hidden" => name.includes?("hidden")
      }
    end
  end
  
  def load_audios(token, path)
    load_yandexDiskfiles(token, path).map do |x|
      name = x["name"].as_s
      {
        "type" => "audio",
        "url" => x["file"],
        "name" => name,
        # "preview" => x["preview"],
        "date" => name[0...10],
        "year" => name[0...4],
        "is_hidden" => name.includes?("hidden")
      }
    end
  end
  
  def load_photos(token, originals_path, previews_path)
    originals = load_yandexDiskfiles(token, originals_path).index_by { |x| x["name"].as_s }
    previews = load_yandexDiskfiles(token, previews_path)

    previews.map do |x|
      name = x["name"].as_s
      url = originals[name]["file"]
      {
        "type" => "photo",
        "url" => url,
        "name" => name,
        "preview" => x["file"],
        "date" => name[0...10],
        "year" => name[0...4],
        "is_hidden" => name.includes?("hidden")
      }
    end
  end

  def load_yandexDiskfiles(token, path)
    json = Crest.get(
      "https://cloud-api.yandex.net/v1/disk/resources",
      params: {"path" => path, "limit" => 1000 },
      headers: {"Accept" => "application/json", "Authorization" => "OAuth #{token}"},
    ).body
    JSON.parse(json)["_embedded"]["items"].as_a
  end
end

*/