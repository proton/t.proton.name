.row.justify-content-center
  .col-sm-12.col-md-6
    - medias.each do |media|
      .container class="container_#{media["type"]}"
        - if media["type"] == "video"
          video src=media["url"] controls type="video/mp4" preload="metadata"


/ <?php
/ $show_hidden = $_GET['hidden'];
/ echo $show_hidden;
/ $notes_h = array();
/ foreach(array('music','photo','video') as $type)
/ {
/   $files = array_diff(scandir('./content/'.$type), array('..', '.'));
/   foreach($files as $f)
/   {
/     if((strpos($f, 'hidden') !== FALSE) && !$show_hidden) next;
/     $date = substr($f, 0, 10);
/     if(!array_key_exists($date, $notes_h)) $notes_h[$date] = array();
/     $notes_h[$date][] = array('date' => $date, 'type' => $type, 'path' => "/content/".$type."/".$f);
/   }
/ }
/ $notes = array();
/ ksort($notes_h);
/ foreach($notes_h as $date => $notes_a)
/ {
/   $notes = array_merge ($notes,  $notes_a);
/ }
/ $years = array();
/ for($y = 1988; $y<=date('Y'); $y=$y+1)
/ {
/   $years[$y] = false;
/ }
/ $notes = array_reverse($notes);
/ krsort($years);
/ ?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
/ <html xmlns="http://www.w3.org/1999/xhtml">
/ <head>
/ <link rel="SHORTCUT ICON" href="/img/ico.png" />
/ <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
/ <title>proton blog</title>

/ <!-- Style Sheet -->
/ <link rel="stylesheet" type="text/css" media="all" href="/css/main.css" />
/ <!-- JavaScripts -->

/ </head>
/ <body>
/ <div id="wrap">
/ <?php foreach($notes as $note): ?>
/ <?php if(substr($note['date'], 0, 1) === '.') continue; ?>
/ <div class="container container_<?php echo $note['type']; ?>" title="<?php echo $note['date']; ?>">
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

/ <ul class='ruler'>
/ <?php
/ foreach($years as $year => $present)
/ {
/   if(substr($year, 0, 1) === '.') continue;
/   if($present)
/   {
/     echo "<li><a href='#year_$year'>$year</a></li>";
/   }
/   else
/   {
/     echo "<li>$year</li>";
/   }
/ }
/ ?>
/ </ul>