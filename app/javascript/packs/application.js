require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

import 'bootstrap'
import "@fortawesome/fontawesome-free/js/all"

import './answers'
import './questions'

import '../stylesheets/application.scss'

window.jQuery = $;
window.$ = $;
