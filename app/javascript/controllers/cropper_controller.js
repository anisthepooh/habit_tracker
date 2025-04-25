import { Controller } from "@hotwired/stimulus";
import Cropper from "cropperjs";

// Connects to data-controller="images"
export default class extends Controller {
  static targets = ["source", "output", "cropButton"];
  connect() {
    this.sourceTarget.addEventListener("load", () => {
      console.log("Image loaded");
      this.createCropper();
    });
  }

  createCropper() {
    this.cropper = new Cropper(this.sourceTarget, {
      autoCropArea: 1,
      aspectRatio: 1,
      viewMode: 1,
      dragMode: "move",
      responsive: true,
      center: true,
    });
  }

  click = (e) => {
    e.preventDefault();

    const outsidePreview = document.querySelector("#cropped-preview")

    outsidePreview.src = this.cropper
      .getCropperSelection()
      .$toCanvas()
      .then((canvas) => {
        outsidePreview.src = canvas.toDataURL();
        this.postToAPI(canvas.toDataURL());
      });
  };

  postToAPI(croppedData) {
    const user_id = this.data.get("id");
    const dataURL = croppedData;

    fetch(`/croppable/${user_id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: JSON.stringify({
        user: {
          cropped_avatar: dataURL,
        },
      }),
    });
  }
}