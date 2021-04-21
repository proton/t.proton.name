require "crest"

class HomeController < ApplicationController
  def index
    yandex_disk_token = ENV["YANDEX_DISK_TOKEN"]
    yandex_disk_video_path = ENV["YANDEX_DISK_VIDEO_PATH"]
    yandex_disk_audio_path = ENV["YANDEX_DISK_AUDIO_PATH"]
    yandex_disk_photo_full_path = ENV["YANDEX_DISK_PHOTO_FULL_PATH"]
    yandex_disk_photo_preview_path = ENV["YANDEX_DISK_PHOTO_PREVIEW_PATH"]

    videos = load_videos(yandex_disk_token, yandex_disk_video_path)
    audios = load_audios(yandex_disk_token, yandex_disk_audio_path)
    photos = load_photos(yandex_disk_token, yandex_disk_photo_full_path, yandex_disk_photo_preview_path)

    medias = videos + audios + photos
    medias = medias.sort_by { |m| m["date"].to_s }.reverse

    years = medias.map { |m| m["year"] }.uniq
    render("index.slang")
  end
  
  def load_videos(token, path)
    load_yandex_disk_files(token, path).map do |x|
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
    load_yandex_disk_files(token, path).map do |x|
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
    originals = load_yandex_disk_files(token, originals_path).index_by { |x| x["name"].as_s }
    previews = load_yandex_disk_files(token, previews_path)

    previews.map do |x|
      name = x["name"].as_s
      url = originals[name]["file"]
      {
        "type" => "photo",
        "url" => url,
        "name" => name,
        "preview" => x["preview"],
        "date" => name[0...10],
        "year" => name[0...4],
        "is_hidden" => name.includes?("hidden")
      }
    end
  end

  def load_yandex_disk_files(token, path)
    json = Crest.get(
      "https://cloud-api.yandex.net/v1/disk/resources",
      params: {"path" => path, "limit" => 1000 },
      headers: {"Accept" => "application/json", "Authorization" => "OAuth #{token}"},
    ).body
    JSON.parse(json)["_embedded"]["items"].as_a
  end
end
