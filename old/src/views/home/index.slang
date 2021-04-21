.row.justify-content-center
  .col-sm-12.col-md-6
    - medias.each do |media|
      - next if media["is_hidden"]
      .container class="container_#{media["type"]}" title=media["date"]
        a name="year_#{media["year"]}"
        - if media["type"] == "video"
          video src=media["url"] controls type="video/mp4" preload="metadata"
        - if media["type"] == "audio"
          audio src=media["url"] controls type="audio/mp3" preload="metadata"
        - if media["type"] == "photo"
          a href=media["url"] target="_blank"
            img src=media["preview"]

ul.ruler
  - years.each do |year|
    li
      a href="#year_#{year}"
        = year
