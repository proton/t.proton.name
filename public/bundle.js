(function() {
  const audios = document.getElementsByTagName('audio')
  const videos = document.getElementsByTagName('video')
  const medias = [...audios, ...videos]

  for (const media of medias) {
    media.addEventListener('play', _ => {
      for (const otherMedia of medias) {
        if (media === otherMedia) continue
        otherMedia.pause();
        otherMedia.currentTime = 0;
      }
    })
  }
})()
