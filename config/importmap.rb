# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@7.1.0/app/assets/javascripts/rails-ujs.esm.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'stimulus-autocomplete', to: 'https://ga.jspm.io/npm:stimulus-autocomplete@3.1.0/src/autocomplete.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'