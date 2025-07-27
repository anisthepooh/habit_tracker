import { Application } from "@hotwired/stimulus"
import PasswordVisibility from '@stimulus-components/password-visibility'



const application = Application.start()
application.register('password-visibility', PasswordVisibility)



// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
