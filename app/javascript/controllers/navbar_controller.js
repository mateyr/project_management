import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["menu"]
  connect() {
    console.log("Entra aquí")
    this.menuTarget.classList.add("hidden")
  }

  toggle(){
    this.menuTarget.classList.toggle("hidden")
  }
}
