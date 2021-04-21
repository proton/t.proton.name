.row.justify-content-center
  .col-sm-12.col-md-6
    - medias.each do |media|
      - next if media["is_hidden"]
      .container class="container_#{media["type"]}" title=media["date"]
        a name="year_#{media["year"]}"
        - if media["type"] == "video"
          video src=media["url"] controls type="video/mp4" preload="metadata"

ul.ruler
  - years.each do |year|
    li
      a href="#year_#{year}"
        = year

/ <?php foreach($notes as $note): ?>
/ <?php
/ $year = substr($note['date'], 0, 4);
/ if(!$years[$year])
/ {
/   $years[$year] = true;
/   echo "<a name='year_$year'></a>";
/ }
/ ?>
/ <?php if($note['type']=='music'): ?>
/ <audio src="<?php echo $note['path']; ?>" controls type="audio/mp3" preload="metadata"></audio>
/ <?php endif; ?>
/ <?php if($note['type']=='photo'): ?>
/ <a href="<?php echo str_replace("photo","photo_original",$note['path']); ?>" target='_blank'><img src="<?php echo $note['path']; ?>"></a>
/ <?php endif; ?>
/ <?php if($note['type']=='video'): ?>
/ <video src="<?php echo $note['path']; ?>" controls type="video/mp4" preload="metadata"></audio>
/ <?php endif; ?>
/ </div>
/ <?php endforeach; ?>
/ </div>