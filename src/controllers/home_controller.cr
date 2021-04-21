require "crest"

class HomeController < ApplicationController
  def index
    yandex_disk_token = ENV["YANDEX_DISK_TOKEN"]
    yandex_disk_video_path = ENV["YANDEX_DISK_VIDEO_PATH"]

    videos = load_videos(yandex_disk_token, yandex_disk_video_path)
    medias = videos
    medias = medias.reverse
    # years = medias.map { |m| m["year"] }.uniq.sort
    render("index.slang")
  end
  
  def load_videos(token, path)
    load_yandex_disk_files(token, path).map do |x|
      name = x["name"].as_s
      {
        "type" => "video",
        "url" => x["file"],
        "name" => x["name"],
        "preview" => x["preview"],
        "date" => name[0..10],
        "year" => name[0..4],
        "is_hidden" => name.includes?("hidden")
      }
    end
  end

  def load_yandex_disk_files(token, path)
    json = Crest.get(
      "https://cloud-api.yandex.net/v1/disk/resources",
      params: {"path" => path},
      headers: {"Accept" => "application/json", "Authorization" => "OAuth #{token}"},
    ).body
    JSON.parse(json)["_embedded"]["items"].as_a
  end
end
