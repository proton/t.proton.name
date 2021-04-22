document.addEventListener('play', function(e){
  let audios = document.getElementsByTagName('audio');
  for (let i = 0, len = audios.length; i < len; ++i) {
    if (audios[i] != e.target) {
      audios[i].pause();
      audios[i].currentTime = 0;
    }
  }
}, true);