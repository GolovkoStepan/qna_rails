require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("@nathanvda/cocoon")

import 'bootstrap'
import "@fortawesome/fontawesome-free/js/all"

import './answers'
import './gist-dynamic-load'
import './vote'

import '../stylesheets/application.scss'

window.jQuery = $;
window.$ = $;
