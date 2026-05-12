# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# Correct pin for Popper.js used by Bootstrap dropdowns. The previous alias "@popperjs--core.js" does not export the expected createPopper function.
pin "@popperjs/core", to: "popper.js", preload: true # @2.11.8
pin "bootstrap" # @5.3.8
