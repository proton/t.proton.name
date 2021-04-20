require "crest"

class HomeController < ApplicationController
  def index
    yandex_disk_token = ENV["YANDEX_DISK_TOKEN"]

    photos = Crest.get(
      "https://cloud-api.yandex.net/v1/disk/resources?path=t.proton.name-content%2Fphoto",
      params: {:lang => "en"},
      headers: {"Accept" => "application/json", "Authorization" => "OAuth #{yandex_disk_token}"},
    )

    render("index.slang")
  end
end
