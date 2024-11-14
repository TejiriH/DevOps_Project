document.getElementById("clickButton").addEventListener("click", () => {
    const messageElement = document.getElementById("message");
    messageElement.textContent = "You clicked the button!";
    messageElement.style.color = "green";
});
