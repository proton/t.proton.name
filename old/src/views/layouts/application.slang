doctype html
html
  head
    title proton blog
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    link rel="stylesheet" href="/dist/main.bundle.css"
    link rel="icon" href="/favicon.png"
    link rel="icon" type="image/x-icon" href="/ico.png"

  body
    #wrapper
      == content

    script src="/dist/main.bundle.js"

    - if Amber.settings.auto_reload?
      script src="/js/client_reload.js"