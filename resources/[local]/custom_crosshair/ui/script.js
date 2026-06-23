window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.action === "show") {
        document.getElementById("crosshair-container").style.display = "flex";
    } else if (data.action === "hide") {
        document.getElementById("crosshair-container").style.display = "none";
    } else if (data.action === "setModel") {
        // Hide all models
        let models = document.getElementsByClassName("crosshair-model");
        for (let i = 0; i < models.length; i++) {
            models[i].classList.remove("active");
        }
        
        // Show selected model
        let selectedModel = document.getElementById("model-" + data.model);
        if (selectedModel) {
            selectedModel.classList.add("active");
        }
    }
});
